export const fetchJSON = async <T = any>(input: RequestInfo | URL, init?: RequestInit | undefined): Promise<T> => {
  try {
    const response = await fetch(input, init)
    return (await response.json()) as T
  } catch (e: any) {
    throw new Error(e.message)
  }
}
