import "@testing-library/jest-dom";
import dotenv from "dotenv";
import fs from "fs";
import path from "path";

// Resolve .env path relative to frontend/src
const envPath = path.resolve(__dirname, "/.env"); // go up 2 levels to CHAT-APP/.env

if (fs.existsSync(envPath)) {
  const parsed = dotenv.config({ path: envPath }).parsed;
  if (parsed) {
    // Only inject REACT_APP_ variables (required by CRA)
    Object.entries(parsed).forEach(([key, value]) => {
      if (key.startsWith("REACT_APP_")) {
        process.env[key] = value;
      }
    });
    console.log("[Jest] ✅ Loaded REACT_APP_ environment variables from .env");
  }
} else {
  console.warn("[Jest] ⚠️ .env file not found at expected path:", envPath);
}
