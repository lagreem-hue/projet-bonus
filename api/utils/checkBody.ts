/**
 * Validates that all required fields are present and not empty in the request body
 * @param body - The request body object to validate
 * @param keys - Array of field names that must be present
 * @returns true if all fields are present and not empty, false otherwise
 * @example
 * checkBody(req.body, ['email', 'password']) // returns true if both fields exist
 */
export function checkBody(body: Record<string, unknown>, keys: string[]): boolean {
  let isValid = true;

  for (const field of keys) {
    if (!body[field] || body[field] === '') {
      console.log(`[VALIDATION ERROR] Missing or empty field: ${field}`);
      isValid = false;
    }
  }

  return isValid;
}