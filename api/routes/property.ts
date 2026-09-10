import express, { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';
import { error } from 'console';
import { truncate } from 'fs';

const router = express.Router();
const prisma = new PrismaClient();

// POST /properties : create a property
router.post('/', async (req: Request, res: Response) => {
    const hostId = req.body.hostId;
    const {
        title,
        description,
        propertyType,
        address,
        city,
        country,
        postalCode,
        maxGuests,
        bedrooms,
        beds,
        bathrooms,
        pricePerNight,
        cleaningFee,
        currency,
        amenities,
        houseRules,
        instantBooking
    } = req.body;

    // Validation fields you need
    if (!hostId || !title || !description || !propertyType || !address || !city || !country || !maxGuests || !pricePerNight) {
        return res.status(400).json({ 
            result: false, 
            error: 'Missing required fields: hostId, title, description, propertyType, address, city, country, maxGuests, pricePerNight' 
        });
    }

    try {
        const newProperty = await prisma.property.create({
            data: {
                hostId: parseInt(String(hostId)),
                title,
                description,
                propertyType,
                address,
                city,
                country,
                postalCode: postalCode || null,
                maxGuests: parseInt(maxGuests),
                bedrooms: bedrooms ? parseInt(bedrooms) : 0,
                beds: beds ? parseInt(beds) : 0,
                bathrooms: bathrooms ? parseFloat(bathrooms) : 1.0,
                pricePerNight: parseFloat(pricePerNight),
                cleaningFee: cleaningFee ? parseFloat(cleaningFee) : 0,
                currency: currency || 'EUR',
                amenities: amenities || {},
                houseRules: houseRules || {},
                instantBooking: instantBooking === true || instantBooking === 'true'
            },
            include: {
                host: {
                    select: {
                        id: true,
                        firstName: true,
                        lastName: true,
                        email: true
                    }
                }
            }
        });

        res.status(201).json({ 
            result: true, 
            property: newProperty,
            message: 'Property created successfully' 
        });
    } catch (error) {
        console.error('Error creating property:', error);
        res.status(500).json({ 
            result: false, 
            error: 'Error during creation property.' 
        });
    }
});

// GET /properties : list all properties
router.get('/', async (req: Request, res: Response) => {
    try {
        // Filtering options
        const { city, country, maxPrice, minPrice, propertyType, isActive } = req.query;

        // Construction dynamic filter
        const where: any = {};

        if (city) where.city = { contains: String(city), mode: 'insensitive' };
        if (country) where.country = { contains: String(country), mode: 'insensitive' };
        if (propertyType) where.propertyType = String(propertyType);
        if (isActive !== undefined) where.isActive = isActive === 'true';
        
        if (minPrice || maxPrice) {
            where.pricePerNight = {};
            if (minPrice) where.pricePerNight.gte = parseFloat(String(minPrice));
            if (maxPrice) where.pricePerNight.lte = parseFloat(String(maxPrice));
        }

        const properties = await prisma.property.findMany({
            where: Object.keys(where).length > 0 ? where : undefined,
            include: {
                host: {
                    select: {
                        id: true,
                        firstName: true,
                        lastName: true,
                        email: true,
                        profilePicture: true
                    }
                },
                images: {
                    where: { isCover: true },
                    take: 1
                },
                _count: {
                    select: {
                        reviews: true,
                        bookings: true
                    }
                }
            },
            orderBy: {
                createdAt: 'desc'
            }
        });

        res.status(200).json({ 
            result: true, 
            properties,
            count: properties.length 
        });
    } catch (error) {
        console.error('Error fetching properties:', error);
        res.status(500).json({
            result: false, 
            error: 'Error during properties recovery' 
        });
    }
});

// GET /properties/:id : property details
router.get('/:id', async (req: Request, res: Response) => {
    const id = parseInt(req.params.id);

    if (isNaN(id)) {
        return res.status(400).json({ 
            result: false, 
            error: 'Invalid property ID' 
        });
    }

    try {
        const property = await prisma.property.findUnique({
            where: { id },
            include: {
                host: {
                    select: {
                        id: true,
                        firstName: true,
                        lastName: true,
                        email: true,
                        phone: true,
                        profilePicture: true,
                        createdAt: true,
                        hostProfile: {
                            select: {
                                isSuperhost: true,
                                responseRate: true,
                                responseTimeHours: true,
                                averageRating: true,
                                hostSince: true
                            }
                        }
                    }
                },
                images: {
                    orderBy: {
                        displayOrder: 'asc'
                    }
                },
                reviews: {
                    take: 10,
                    orderBy: {
                        createdAt: 'desc'
                    },
                    include: {
                        author: {
                            select: {
                                firstName: true,
                                lastName: true,
                                profilePicture: true
                            }
                        }
                    }
                },
                _count: {
                    select: {
                        reviews: true,
                        bookings: true
                    }
                }
            }
        });

        if (!property) {
            return res.status(404).json({ 
                result: false, 
                error: 'Property not found' 
            });
        }

        // Incrémenter le compteur de vues
        await prisma.property.update({
            where: { id },
            data: { viewCount: { increment: 1 } }
        });

        res.status(200).json({ 
            result: true, 
            property 
        });
    } catch (error) {
        console.error('Error fetching property details:', error);
        res.status(500).json({ 
            result: false, 
            error: 'Error during property recovery'
        });
    }
});

// DELETE /properties/:id : delete a property (soft delete)
router.delete('/:id', async (req: Request, res: Response) => {
    const id = parseInt(req.params.id);

    if (isNaN(id)) {
        return res.status(400).json({ 
            result: false, 
            error: 'ID d\'annonce invalide' 
        });
    }

    try {
        // check if property exist
        const existingProperty = await prisma.property.findUnique({
            where: { id },
            include: {
                bookings: {
                    where: {
                        status: {
                            in: ['pending', 'confirmed']
                        }
                    }
                }
            }
        });

        if (!existingProperty) {
            return res.status(404).json({
                result: false,
                error: "Property not found"
            });
        }

        // Check if properties is active
        if (existingProperty.bookings.length > 0) {
            return res.status(400).json({
                result: false,
                error: "Cannot delete property with active bookings. Cancel all booking first."
            });
        }

        // Soft delete the property
        const deletedProperty = await prisma.property.update({
            where: { id },
            data: {
                isActive: false,
            },
            include: {
                host: {
                    select: {
                        id: true,
                        firstName: true,
                        lastName: true,
                        email: true
                    }
                }
            }
        });

        res.status(200).json({
            result: true,
            message: 'Property deleted successfully',
            property: deletedProperty
        });

    } catch (error){
        console.error('Error deleting property:', error);
        res.status(500).json({
            result: false,
            error: 'Error during property deletion'
        })
    }
});

export default router;