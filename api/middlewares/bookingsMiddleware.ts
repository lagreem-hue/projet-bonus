import { Request, Response, NextFunction } from "express";
import jwt from 'jsonwebtoken';

export function bookingsMiddleware (req: Request, res: Response, next: NextFunction){
    try {
        // take the token from the authorization
        const authHeader = req.headers.authorization;
    
        if (!authHeader || !authHeader.startsWith('Bearer ')) {
            return res.status(401).json({
                result: false,
                error: "Access token required"
            });
        }

        // remove 'Bearer ' from the token
        const token = authHeader.substring(7);

        // check token with the secret key
        const decoded = jwt.verify(token, process.env.JWT_SECRET as string) as { userId: number};
    
        // add the userId to the request for the next steps
        req.userId = decoded.userId;

        next();

    } catch (error){
        // handle errors
        if (error instanceof jwt.TokenExpiredError) {
            return res.status(401).json({
                result: false,
                error: "Token expired"
            });
        }
        return res.status(401).json({
            result: false,
            error: "Invalid token"
        });
    }
};