import express, { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';
import { bookingsMiddleware } from '../middlewares/bookingsMiddleware';

const router = express.Router();
const prisma = new PrismaClient();

// POST /bookings : create a booking
router.post('/', bookingsMiddleware, async (req: Request, res: Response) => {
    // Recovery user's ID with JWT middleware
    const guestId = req.userId;
    const { propertyId, checkInDate, checkOutDate, numberOfGuests, totalPrice } = req.body;

    if (!guestId) {
        return res.status(401).json({ result: false, error: "Authentication required." });
    }

    if (!propertyId || !checkInDate || !checkOutDate || !numberOfGuests || !totalPrice) {
        return res.status(400).json({ result: false, error: "Missing required booking fields." });
    }
    try {
        const newBooking = await prisma.booking.create({
            data: {
                propertyId,
                guestId,
                checkInDate: new Date(checkInDate),
                checkOutDate: new Date(checkOutDate),
                numberOfGuests,
                pricePerNight: 0, // Will be fetched from property
                totalPrice: parseFloat(totalPrice),
                status: "pending",
                paymentStatus: "pending"
            },
            include: {
                property: {
                    select: { title: true, address: true, pricePerNight: true }
                },
                guest: {
                    select: { firstName: true, lastName: true, email: true }
                }
            }
        });
        res.status(201).json({ result: true, booking: newBooking });
    } catch (error) {
        res.status(500).json({ result: false, error: "Error during booking creation." })
    }
});

// GET /bookings : list all bookings
router.get('/', bookingsMiddleware, async (req: Request, res: Response) => {
    try {
        const bookings = await prisma.booking.findMany({
            include: {
                property: {
                    select: { title: true, address: true }
                },
                guest: {
                    select: { firstName: true, lastName: true, email: true }
                }
            }
        });
        res.status(200).json({ result: true, bookings });
    } catch (error) {
        res.status(500).json({ result: false, error: "Error during bookings retrieval." });
    }
});

// GET /bookings/:id : show details from one booking
router.get('/:id', bookingsMiddleware, async (req: Request, res: Response) => {
    const id = parseInt(req.params.id);

    if (isNaN(id)) {
        return res.status(400).json({ result: false, error: "Invalid booking ID." });
    }
    
    try {
        const booking = await prisma.booking.findUnique({
            where: { id },
            include: {
                property: {
                    select: { title: true, address: true, pricePerNight: true }
                },
                guest: {
                    select: { firstName: true, lastName: true, email: true }
                }
            }
        });
        
        if (!booking) {
            return res.status(404).json({ result: false, error: "Booking not found." });
        }
        
        res.status(200).json({ result: true, booking });
    } catch (error) {
        res.status(500).json({ result: false, error: "Error during booking retrieval." })
    }
});

// PUT /bookings/:id : update a booking
router.put('/:id', bookingsMiddleware, async (req: Request, res: Response) => {
    const id = parseInt(req.params.id);
    const userId = req.userId;
    const { checkInDate, checkOutDate, numberOfGuests, totalPrice } = req.body;
    
    if (isNaN(id)) {
        return res.status(400).json({ result: false, error: "Invalid booking ID." });
    }

    if (!userId) {
        return res.status(401).json({ result: false, error: "Authentication required." });
    }

    try {
        // Conditions to make modifications
        const existingBooking = await prisma.booking.findUnique({
            where: { id }
        });
        if (!existingBooking) {
            return res.status(404).json({ result: false, error: "Booking not found."});
        }

        if (existingBooking.guestId !== userId) {
            return res.status(403).json({ result: false, error: "You can only change your own bookings."});
        }

        if (existingBooking.status !== "pending") {
            return res.status(400).json({ result: false, error: "You can only change pending bookings."});
        }

        // Update when conditions are ok
        const updatedBooking = await prisma.booking.update({
            where: {id},
            data: {
                ...(checkInDate && { checkInDate: new Date(checkInDate) }),
                ...(checkOutDate && { checkOutDate: new Date(checkOutDate) }),
                ...(numberOfGuests && { numberOfGuests }),
                ...(totalPrice && { totalPrice: parseFloat(totalPrice) })
            },
            include: {
                property: {
                    select: { title: true, address: true, pricePerNight: true }
                    },
                guest: {
                    select: { firstName: true, lastName: true, email: true }
                }
            }
        });

        res.status(200).json({ result: true, booking: updatedBooking });
    } catch (error) {
        res.status(500).json({ result: false, error: "Error during update."})
    }
});

// DELETE /bookings/:id : delete a booking
router.delete('/:id', bookingsMiddleware, async (req: Request, res: Response) => {
    const id = parseInt(req.params.id);
    const userId = req.userId;
    const { checkInDate, checkOutDate, numberOfGuests, totalPrice } = req.body;
    
    if (isNaN(id)) {
        return res.status(400).json({ result: false, error: "Invalid booking ID." });
    }

    if (!userId) {
        return res.status(401).json({ result: false, error: "Authentication required." });
    }

    try {
        // Conditions to delete
        const existingBooking = await prisma.booking.findUnique({
            where: { id }
        });
        if (!existingBooking) {
            return res.status(404).json({ result: false, error: "Booking not found."});
        }

        if (existingBooking.guestId !== userId) {
            return res.status(403).json({ result: false, error: "You can only change your own bookings."});
        }

        if (existingBooking.status === "cancelled") {
            return res.status(400).json({ result: false, error: "Booking is already cancelled."});
        }

        // Soft delete
        const cancelledBooking = await prisma.booking.update({
            where: {id},
            data: {
                status: "cancelled",
                cancelledAt: new Date(),
                cancellationReason: req.body.reason || "Cancelled by user."
            },
            include: {
                property: {
                    select: { title: true, address: true }
                    },
                guest: {
                    select: { firstName: true, lastName: true, email: true }
                }
            }
        });

        res.status(200).json({ result: true, message:"Booking cancelled successfully.", booking: cancelledBooking });
    } catch (error) {
        res.status(500).json({ result: false, error: "Error during cancellation."})
    }
});



export default router;
