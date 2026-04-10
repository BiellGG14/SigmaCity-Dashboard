const DEFAULT_API_URL = "http://127.0.0.1:8000";

export function getApiBaseUrl() {
  return process.env.API_INTERNAL_URL || process.env.NEXT_PUBLIC_API_URL || DEFAULT_API_URL;
}

export function getPublicApiBaseUrl() {
  return process.env.NEXT_PUBLIC_API_URL || DEFAULT_API_URL;
}

export async function fetchApi(path, options = {}) {
  const baseUrl = getApiBaseUrl().replace(/\/$/, "");
  const response = await fetch(`${baseUrl}${path}`, {
    cache: "no-store",
    ...options,
  });

  if (!response.ok) {
    throw new Error(`API request failed: ${response.status} ${response.statusText}`);
  }

  return response.json();
}

export function getWordCloudUrl(imageBase) {
  if (!imageBase) {
    return null;
  }

  const baseUrl = getPublicApiBaseUrl().replace(/\/$/, "");
  return `${baseUrl}/api/imagens?nome_img=${encodeURIComponent(`${imageBase}_nuvem.png`)}`;
}
