/**
 * Validates email format using regex pattern
 * @param email - The email address to validate
 * @returns Object with result boolean and optional error message
 * @example
 * checkEmailFormat('user@example.com') // returns { result: true }
 * checkEmailFormat('invalid-email') // returns { result: false, error: '...' }
 */
export function checkEmailFormat(email: string): { result: boolean; error?: string } {
   const emailReg = new RegExp(
      /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))/i
    );
    
    if (emailReg.test(email)){
          return { result: true };
  } else {
    return {
      result: false,
      error: "Invalid email format. Please enter a valid email address",
    };
  }
    }
   

