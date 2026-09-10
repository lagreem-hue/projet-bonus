// Extension of the Express Request type to include userId
declare global {
    namespace Express {
        interface Request {
            userId?: number;
        }
    }
}

// empty export in order to TypeScript see it as a module
export {};