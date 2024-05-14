export function isNotBlank(content?: string): boolean {
  if (content == null) {
    return false
  }
  if (typeof content === 'string') {
    return content.trim().length > 0
  }
  return false
}