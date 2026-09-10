import express, { Request, Response } from "express";
import { PrismaClient } from "@prisma/client";
import { checkBody } from "../utils/checkBody";
import { RegisterRequestBody, LoginRequestBody } from "../types/auth.types.js";
import dotenv from "dotenv";
dotenv.config();

const router = express.Router();
const prisma = new PrismaClient();

/**
 * @swagger
 * /users:
 *   post:
 *     summary: Create a new user
 *     description: Create a user without authentication (Simple CRUD for testing)
 *     tags: [Users]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - email
 *               - firstName
 *               - lastName
 *             properties:
 *               email:
 *                 type: string
 *                 format: email
 *                 example: newuser@example.com
 *               firstName:
 *                 type: string
 *                 example: Jane
 *               lastName:
 *                 type: string
 *                 example: Smith
 *     responses:
 *       200:
 *         description: User created successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 result:
 *                   type: boolean
 *                   example: true
 *                 user:
 *                   type: object
 *       400:
 *         description: Missing required fields
 */
router.post("/", async (req: Request, res: Response) => {
  if (!checkBody(req.body, ["email", "firstName", "lastName"])) {
    return res.json({ result: false, error: "Missing fields" });
  }

  const newUser = await prisma.user.create({
    data: {
      email: req.body.email,
      firstName: req.body.firstName,
      lastName: req.body.lastName,
      passwordHash: "", // No password in simple CRUD
    },
  });

  res.json({ result: true, user: newUser });
});

/**
 * @swagger
 * /users:
 *   get:
 *     summary: Get all users
 *     description: Retrieve a list of all registered users
 *     tags: [Users]
 *     responses:
 *       200:
 *         description: List of users retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 result:
 *                   type: boolean
 *                   example: true
 *                 users:
 *                   type: array
 *                   items:
 *                     type: object
 *                     properties:
 *                       id:
 *                         type: integer
 *                       email:
 *                         type: string
 *                       firstName:
 *                         type: string
 *                       lastName:
 *                         type: string
 */
router.get("/", async (req: Request, res: Response) => {
  const users = await prisma.user.findMany();
  res.json({ result: true, users });
});

/**
 * @swagger
 * /users/{id}:
 *   get:
 *     summary: Get a user by ID
 *     tags: [Users]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: User found
 *       400:
 *         description: Invalid ID
 *       404:
 *         description: User not found
 *       500:
 *         description: Server error
 */
router.get("/:id", async (req: Request, res: Response) => {
  // Parse user ID from URL parameter and convert to integer
  // URL params are always strings, so we need to convert to number
  const userId = parseInt(req.params.id);

  // Check if conversion to integer failed (e.g., if user passed "abc" instead of "123")
  // isNaN() returns true if the value is Not a Number
  if (isNaN(userId)) {
    return res.status(400).json({
      result: false,
      error: "Invalid ID",
    });
  }
  try {
    const user = await prisma.user.findUnique({
      where: { id: userId },
    });

    if (!user) {
      return res.status(404).json({
        result: false,
        error: "User not found",
      });
    }

    return res.status(200).json({
      result: true,
      user: {
        id: user.id,
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
        phone: user.phone,
      },
    });
  } catch (error: any) {
    console.error("Error during query", error);
    return res.status(500).json({
      result: false,
      error: "Server error during query",
    });
  }
});

/**
 * @swagger
 * /users/{id}:
 *   delete:
 *     summary: Delete a user
 *     tags: [Users]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: User deleted successfully
 *       404:
 *         description: User not found
 *       500:
 *         description: Server error
 */
router.delete("/:id", async (req: Request, res: Response) => {
  const userId = parseInt(req.params.id);

  if (isNaN(userId)) {
    return res.status(400).json({
      result: false,
      error: "Invalid ID",
    });
  }
  try {
    const user = await prisma.user.findUnique({
      where: { id: userId },
    });

    if (!user) {
      return res.status(404).json({
        result: false,
        error: "User not found",
      });
    }

    // Delete user - Prisma will handle cascade deletion for related records
    await prisma.user.delete({
      where: { id: userId },
    });
    return res.json({
      result: true,
      message: `User ${userId} deleted successfully`,
    });
  } catch (error: any) {
    console.error("Error during deletion", error);
    return res.status(500).json({
      result: false,
      error: "Server error during deletion",
    });
  }
});

export default router;
