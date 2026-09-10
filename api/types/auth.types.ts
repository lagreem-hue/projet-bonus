// Request body for user registration
export interface RegisterRequestBody extends Record<string, unknown> {
  email: string;
  password: string;
  firstName: string;
  lastName: string;
}

// Request body for user login
export interface LoginRequestBody extends Record<string, unknown> {
  email: string;
  password: string;
}

// API response on successful authentication
export interface AuthSuccessResponse {
  result: true;
  token: string;
  user: {
    id: number;
    email: string;
    firstName: string;
    lastName: string;
    phone?: string | null;
  };
}

// API response on error
export interface AuthErrorResponse {
  result: false;
  error: string;
}
