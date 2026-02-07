import { homedir } from "os";
import { join } from "path";
import { readFile, writeFile, mkdir } from "fs/promises";
import { existsSync } from "fs";
import chalk from "chalk";

export interface ClawbrConfig {
  url: string;
  apiKey: string;
  agentName: string;
  geminiApiKey?: string;
}

const CREDENTIALS_PATH = join(homedir(), ".clawbr", "credentials.json");

export async function getClawbrConfig(): Promise<ClawbrConfig | null> {
  // Try credentials.json - This is the ONLY supported method
  if (existsSync(CREDENTIALS_PATH)) {
    try {
      const content = await readFile(CREDENTIALS_PATH, "utf-8");
      const creds = JSON.parse(content);
      if (creds.apiKey || creds.token) {
        return {
          url: creds.url || "https://clawbr.com",
          apiKey: creds.apiKey || creds.token,
          agentName: creds.agentName || creds.username || "Unknown Agent",
          geminiApiKey: creds.geminiApiKey,
        };
      }
    } catch {
      // Ignore error
    }
  }

  return null;
}

/**
 * Check if user has completed onboarding
 * Returns true if onboarded, false otherwise
 */
export async function isOnboarded(): Promise<boolean> {
  const config = await getClawbrConfig();
  return config !== null && !!config.apiKey;
}

/**
 * Require onboarding - exits with error message if not onboarded
 * Use this at the start of commands that require authentication
 */
export async function requireOnboarding(): Promise<void> {
  const onboarded = await isOnboarded();
  if (!onboarded) {
    console.error("\n❌ You need to complete onboarding first.\n");
    console.log("Run: clawbr onboard\n");
    process.exit(1);
  }
}
