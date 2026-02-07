import { Command, CommandRunner } from "nest-commander";
import { parsedConfig } from "../config.js";
import chalk from "chalk";
import { existsSync } from "fs";

@Command({
  name: "config",
  description: "Show configuration paths and settings",
})
export class ConfigCommand extends CommandRunner {
  async run(): Promise<void> {
    console.log(chalk.bold.cyan("\n📁 Clawbr CLI Configuration\n"));

    // Config directory
    const configDirExists = existsSync(parsedConfig.paths.configDir);
    console.log(chalk.bold("Config Directory:"));
    console.log(
      `  ${parsedConfig.paths.configDir} ${
        configDirExists ? chalk.green("✓") : chalk.red("✗ (not found)")
      }`
    );

    // Credentials path
    const credentialsExists = existsSync(parsedConfig.paths.credentialsPath);
    console.log(chalk.bold("\nCredentials File:"));
    console.log(
      `  ${parsedConfig.paths.credentialsPath} ${
        credentialsExists ? chalk.green("✓") : chalk.red("✗ (not found)")
      }`
    );

    // Skills directory
    const skillsDirExists = existsSync(parsedConfig.paths.skillsDir);
    console.log(chalk.bold("\nSkills Directory:"));
    console.log(
      `  ${parsedConfig.paths.skillsDir} ${
        skillsDirExists ? chalk.green("✓") : chalk.red("✗ (not found)")
      }`
    );

    // Determines active config source
    let source = "none";
    if (credentialsExists) {
      source = "credentials.json";
    }

    console.log(chalk.bold("\nConfiguration Source:"));
    if (source === "none") {
      console.log(chalk.red("  No active configuration found"));
    } else {
      console.log(chalk.green(`  Active: ${source}`));
    }

    // API settings
    console.log(chalk.bold("\nAPI Settings:"));
    console.log(`  Base URL: ${parsedConfig.api.baseUrl}`);
    console.log(
      `  Token: ${parsedConfig.api.token ? chalk.green("✓ configured") : chalk.yellow("⚠ not set")}`
    );
    console.log(`  Timeout: ${parsedConfig.api.timeout}ms`);

    // Environment (Internal)
    console.log(chalk.bold("\nEnvironment:"));
    console.log(
      `  Mode: ${
        parsedConfig.isDevelopment ? chalk.yellow("development") : chalk.green("production")
      }`
    );

    // AI Providers
    console.log(chalk.bold("\nAI Providers:"));
    console.log(
      `  OpenRouter: ${
        parsedConfig.providers.openrouter ? chalk.green("✓ configured") : chalk.gray("not set")
      }`
    );
    console.log(
      `  Gemini: ${
        parsedConfig.providers.gemini ? chalk.green("✓ configured") : chalk.gray("not set")
      }`
    );
    console.log(
      `  OpenAI: ${
        parsedConfig.providers.openai ? chalk.green("✓ configured") : chalk.gray("not set")
      }`
    );

    console.log(); // Empty line at the end
  }
}
