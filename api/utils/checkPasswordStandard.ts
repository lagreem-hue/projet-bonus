/**
 * Validates password complexity requirements
 * Password must contain:
 * - At least 8 characters
 * - At least 1 uppercase letter (e.g., A)
 * - At least 1 lowercase letter (e.g., a)
 * - At least 1 digit (e.g., 1)
 * - At least 1 special character (e.g., !, @, #, $)
 * 
 * @param password - The password string to validate
 * @returns Object with result boolean and optional error message
 * @example
 * checkPasswordStandard('MyP@ssw0rd') // returns { result: true }
 * checkPasswordStandard('weak') // returns { result: false, error: '...' }
 */
export function checkPasswordStandard(password: string): { result: boolean; error?: string } {
  const passwordReg = new RegExp(
    /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z\d])[A-Za-z\d\S]{8,}$/
  );
  if (passwordReg.test(password)) {
    return { result: true };
  } else {
    return {
      result: false,
      error:
        "Password must be at least 8 characters long and include one uppercase letter (e.g. A), one lowercase letter (e.g. a), one number (e.g. 1), and one special character (e.g. !, @, #, $).",
    };
  }
}

