import express from 'express';
import authRoutes from './routes/auth.js';
import usersRoutes from './routes/users.js';
import bookingsRoutes from './routes/bookings.js';
import dotenv from 'dotenv';
import cors from 'cors'
import swaggerUi from 'swagger-ui-express';
import swaggerJsdoc from 'swagger-jsdoc'


dotenv.config();

const app = express();

const PORT = process.env.PORT || 4000;

app.use(express.json());
app.use(cors());
app.use(express.urlencoded({ extended: true }));

app.use('/auth', authRoutes);
app.use('/users', usersRoutes);
app.use('/bookings', bookingsRoutes);


const swaggerOptions = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'ETNAir API',
      version: '1.0.0',
      description: 'Documentation de l\'API du projet ETNAir',
      contact: {
        name: 'Équipe IDV',
      },
    },
    servers: [
      {
        url: `http://localhost:${PORT}`,
        description: 'Serveur local',
      },
    ],
    // Configuration pour le cadenas JWT (Bouton "Authorize")
    components: {
      securitySchemes: {
        bearerAuth: {
          type: 'http',
          scheme: 'bearer',
          bearerFormat: 'JWT',
        },
      },
    },
    security: [
      {
        bearerAuth: [],
      },
    ],
  },

  apis: ['./routes/*.ts'],
  
}

const swaggerDocs = swaggerJsdoc(swaggerOptions);
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocs));

app.get('/', (req, res) => {
  res.json({ message: 'Hello, ETNAir!' });
});


app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
