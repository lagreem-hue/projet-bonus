export function checkPassword(password: string, confirmPassword: string): { result: boolean; error?: string} {
  if (password === confirmPassword) {
    return { result: true };
  } else {
    return {
      result: false,
      error: "Passwords doesn't match. Please Try Again.",
    };
  }
}

