import { Method } from "./types";

export async function fetcher<T>(
  method: Method,
  endpoint: string,
  body?: unknown,
  bypassError: boolean = false
): Promise<any> {
  const request = await fetch(endpoint, {
    method,
    credentials: "include",
    headers: body ? { "Content-Type": "application/json" } : undefined,
    body: body ? JSON.stringify(body) : undefined,
  });

  return request.body;
}

export async function getFile(path: string, repo: string) {}
