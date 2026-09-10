import express, { Request, Response } from "express";
import jwt from "jsonwebtoken";
import bcrypt from "bcrypt";
import { PrismaClient } from "@prisma/client";
import { checkBody } from "../utils/checkBody.js";
import { checkEmailFormat } from "../utils/checkEmailFormat.js";
import { checkPasswordStandard } from "../utils/checkPasswordStandard.js";
import { RegisterRequestBody, LoginRequestBody } from "../types/auth.types.js";
import dotenv from "dotenv";

const router = express.Router();
const prisma = new PrismaClient();

/**
 * @swagger
 * /auth/register:
 *   post:
 *     summary: Create a new user account
 *     description: Register a new user with email, password, firstName, and lastName. Password must meet complexity requirements.
 *     tags: [Authentication]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - email
 *               - password
 *               - firstName
 *               - lastName
 *             properties:
 *               email:
 *                 type: string
 *                 format: email
 *                 example: user@example.com
 *               password:
 *                 type: string
 *                 format: password
 *                 minLength: 8
 *                 example: MyP@ssw0rd
 *                 description: Must contain uppercase, lowercase, digit, and special character
 *               firstName:
 *                 type: string
 *                 example: John
 *               lastName:
 *                 type: string
 *                 example: Doe
 *     responses:
 *       200:
 *         description: User registered successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 result:
 *                   type: boolean
 *                   example: true
 *                 token:
 *                   type: string
 *                   example: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
 *                 user:
 *                   type: object
 *                   properties:
 *                     id:
 *                       type: integer
 *                     email:
 *                       type: string
 *                     firstName:
 *                       type: string
 *                     lastName:
 *                       type: string
 *       400:
 *         description: Validation error (missing fields, invalid email, weak password, user exists)
 *       500:
 *         description: Server error during registration
 */
router.post(
  "/register",
  async (req: Request<{}, {}, RegisterRequestBody>, res: Response) => {
    try {
      // Validate required fields
      if (
        !checkBody(req.body, ["email", "password", "firstName", "lastName"])
      ) {
        return res.json({ result: false, error: "Missing fields" });
      }

      // Validate email format
      const checkEmailResult = checkEmailFormat(req.body.email);
      if (!checkEmailResult.result) {
        return res.json(checkEmailResult);
      }

      // Validate password complexity
      const checkPasswordStandardResult = checkPasswordStandard(
        req.body.password
      );
      if (!checkPasswordStandardResult.result) {
        return res.json(checkPasswordStandardResult);
      }

      // Check if user already exists
      // Normalize email: remove extra spaces and convert to lowercase for consistent comparison
      const email: string = req.body.email.trim().toLowerCase();
      const user = await prisma.user.findUnique({
        where: { email },
      });

      if (user !== null) {
        return res.json({ result: false, error: "User already exists" });
      }

      // Hash the password using bcrypt
      // The second parameter (10) is the salt rounds - higher = more secure but slower
      const hashedPassword: string = await bcrypt.hash(req.body.password, 10);

      // Create the user
      const newUser = await prisma.user.create({
        data: {
          email: email,
          passwordHash: hashedPassword,
          firstName: req.body.firstName,
          lastName: req.body.lastName,
        },
      });

      // Generate JWT token
      // Token contains user ID and email, signed with secret key
      // expiresIn: '24h' means token will be valid for 24 hours
      const token: string = jwt.sign(
        { userId: newUser.id, email: newUser.email },
        process.env.JWT_SECRET || "your-secret-key",
        { expiresIn: "24h" }
      );

      return res.json({
        result: true,
        token,
        user: {
          id: newUser.id,
          email: newUser.email,
          firstName: newUser.firstName,
          lastName: newUser.lastName,
        },
      });
    } catch (error: any) {
      console.error("Error during registration:", error);
      return res.status(500).json({
        result: false,
        error: "Server error during registration",
      });
    }
  }
);

/**
 * @swagger
 * /auth/login:
 *   post:
 *     summary: Authenticate user
 *     description: Login with email and password to receive a JWT token
 *     tags: [Authentication]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - email
 *               - password
 *             properties:
 *               email:
 *                 type: string
 *                 format: email
 *                 example: user@example.com
 *               password:
 *                 type: string
 *                 format: password
 *                 example: MyP@ssw0rd
 *     responses:
 *       200:
 *         description: Login successful
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 result:
 *                   type: boolean
 *                   example: true
 *                 token:
 *                   type: string
 *                   example: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
 *                 user:
 *                   type: object
 *                   properties:
 *                     id:
 *                       type: integer
 *                     email:
 *                       type: string
 *                     firstName:
 *                       type: string
 *                     lastName:
 *                       type: string
 *                     phone:
 *                       type: string
 *       400:
 *         description: Invalid credentials or validation error
 *       500:
 *         description: Server error during login
 */
router.post(
  "/login",
  async (req: Request<{}, {}, LoginRequestBody>, res: Response) => {
    try {
      // Validate required fields
      if (!checkBody(req.body, ["email", "password"])) {
        return res.json({ result: false, error: "Missing fields" });
      }

      // Validate email format
      const checkEmailResult = checkEmailFormat(req.body.email);
      if (!checkEmailResult.result) {
        return res.json(checkEmailResult);
      }

      // Find the user
      // Normalize email: remove extra spaces and convert to lowercase for consistent lookup
      const email: string = req.body.email.trim().toLowerCase();
      const user = await prisma.user.findUnique({
        where: { email },
      });

      if (!user) {
        return res.json({
          result: false,
          error: "Invalid email or password",
        });
      }

      // Verify the password
      // bcrypt.compare() securely compares plain text password with hashed password
      const isPasswordValid: boolean = await bcrypt.compare(
        req.body.password,
        user.passwordHash
      );

      if (!isPasswordValid) {
        return res.json({
          result: false,
          error: "Invalid email or password",
        });
      }

      // Generate JWT token
      const token: string = jwt.sign(
        { userId: user.id, email: user.email },
        process.env.JWT_SECRET || "your-secret-key",
        { expiresIn: "24h" }
      );

      return res.json({
        result: true,
        token,
        user: {
          id: user.id,
          email: user.email,
          firstName: user.firstName,
          lastName: user.lastName,
          phone: user.phone,
        },
      });
    } catch (error: any) {
      console.error("Error during login:", error);
      return res.status(500).json({
        result: false,
        error: "Server error during login",
      });
    }
  }
);

/**
 * @swagger
 * /auth/logout:
 *   post:
 *     summary: Logout user
 *     description: Verify JWT token validity. Stateless logout - client must remove token from storage.
 *     tags: [Authentication]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: header
 *         name: Authorization
 *         required: true
 *         schema:
 *           type: string
 *           example: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
 *         description: JWT token in format "Bearer <token>"
 *     responses:
 *       200:
 *         description: Logout successful - token is valid
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 result:
 *                   type: boolean
 *                   example: true
 *                 message:
 *                   type: string
 *                   example: Logged out
 *       401:
 *         description: Missing or invalid token
 */
router.post("/logout", (req: Request, res: Response) => {
  // Extract JWT token from Authorization header
  // Format expected: "Bearer <token>", so we split by space and take the second part [1]
  const token = req.headers.authorization?.split(" ")[1];

  if (!token) {
    return res.status(401).json({
      result: false,
      error: "Missing token",
    });
  }

  try {
    // Verify token is valid and not expired
    // If token is invalid or expired, jwt.verify() will throw an error
    jwt.verify(token, process.env.JWT_SECRET || "your-secret-key");
  } catch (error: any) {
    console.error("Error verifying token", error);
    return res.status(401).json({
      result: false,
      error: "Server error during token verification",
    });
  }

  return res.json({
    result: true,
    message: "Logged out",
  });
});

export default router;
