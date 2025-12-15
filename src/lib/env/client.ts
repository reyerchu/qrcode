function checkOrDefault(key: string, env: string | undefined, defaultValue: string = "") {
  if (env !== undefined) {
    return env;
  }
  console.warn(`Warning: ${key} is not set, using default value`);
  return defaultValue;
}

export const NEXT_PUBLIC_ACCOUNT_URL = checkOrDefault(
  "NEXT_PUBLIC_ACCOUNT_URL",
  process.env.NEXT_PUBLIC_ACCOUNT_URL,
  "https://account.latentcat.com"
);

export const NEXT_PUBLIC_CLIENT_ID = checkOrDefault(
  "NEXT_PUBLIC_CLIENT_ID",
  process.env.NEXT_PUBLIC_CLIENT_ID,
  ""
);

export const NEXT_PUBLIC_QRBTF_API_ENDPOINT = checkOrDefault(
  "NEXT_PUBLIC_QRBTF_API_ENDPOINT",
  process.env.NEXT_PUBLIC_QRBTF_API_ENDPOINT,
  "https://api.qrbtf.com"
);
