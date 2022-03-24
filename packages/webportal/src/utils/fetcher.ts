import { Method } from "./types";

export async function fetcher<T>(
  method: Method,
  endpoint: string,
  body?: unknown,
  bypassError: boolean = false
): Promise<{ data: T; code: number }> {
  const request = await fetch(`http://localhost.com:8000/${endpoint}`, {
    method,
    credentials: "include",
    headers: body ? { "Content-Type": "application/json" } : undefined,
    body: body ? JSON.stringify(body) : undefined,
  });

  const json: { data: T; code: number } = await request.json();

  if (request.status >= 400 && !bypassError) {
    throw new Error(`${json.data}`);
  }

  return json;
}
