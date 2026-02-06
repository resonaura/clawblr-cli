#!/bin/sh
set -e

# Create OpenClaw config directories
mkdir -p /home/node/.openclaw/agents/main/agent

# Create main openclaw.json config
cat > /home/node/.openclaw/openclaw.json << 'EOF'
{
  "meta": {
    "lastTouchedVersion": "2026.1.30",
    "lastTouchedAt": "2026-02-06T00:00:00.000Z"
  },
  "gateway": {
    "controlUi": {
      "enabled": true,
      "allowInsecureAuth": true,
      "dangerouslyDisableDeviceAuth": true
    }
  },
  "auth": {
    "profiles": {}
  },
  "agents": {
    "defaults": {
      "model": {
        "primary": "openrouter/openrouter/auto"
      },
      "workspace": "/workspace",
      "maxConcurrent": 4
    }
  }
}
EOF

# Create auth-profiles.json with API keys from environment
cat > /home/node/.openclaw/agents/main/agent/auth-profiles.json << EOF
{
  "version": 1,
  "profiles": {},
  "lastGood": {},
  "usageStats": {}
}
EOF

# Add OpenRouter profile if key is set
if [ -n "$OPENROUTER_API_KEY" ]; then
  echo "✓ Configuring OpenRouter"
  cat > /home/node/.openclaw/agents/main/agent/auth-profiles.json << EOF
{
  "version": 1,
  "profiles": {
    "openrouter:default": {
      "type": "api_key",
      "provider": "openrouter",
      "key": "$OPENROUTER_API_KEY"
    }
  },
  "lastGood": {
    "openrouter": "openrouter:default"
  },
  "usageStats": {
    "openrouter:default": {
      "lastUsed": $(date +%s)000,
      "errorCount": 0
    }
  }
}
EOF
  # Update openclaw.json to use OpenRouter
  cat > /home/node/.openclaw/openclaw.json << 'EOF'
{
  "meta": {
    "lastTouchedVersion": "2026.1.30",
    "lastTouchedAt": "2026-02-06T00:00:00.000Z"
  },
  "gateway": {
    "controlUi": {
      "enabled": true,
      "allowInsecureAuth": true,
      "dangerouslyDisableDeviceAuth": true
    }
  },
  "auth": {
    "profiles": {
      "openrouter:default": {
        "provider": "openrouter",
        "mode": "api_key"
      }
    }
  },
  "agents": {
    "defaults": {
      "model": {
        "primary": "openrouter/openrouter/auto"
      },
      "workspace": "/workspace",
      "maxConcurrent": 4
    }
  }
}
EOF
fi

# Add Google profile if key is set
if [ -n "$GEMINI_API_KEY" ] || [ -n "$GOOGLE_API_KEY" ]; then
  API_KEY="${GEMINI_API_KEY:-$GOOGLE_API_KEY}"
  echo "✓ Configuring Google Gemini"
  cat > /home/node/.openclaw/agents/main/agent/auth-profiles.json << EOF
{
  "version": 1,
  "profiles": {
    "google:default": {
      "type": "api_key",
      "provider": "google",
      "key": "$API_KEY"
    }
  },
  "lastGood": {
    "google": "google:default"
  },
  "usageStats": {
    "google:default": {
      "lastUsed": $(date +%s)000,
      "errorCount": 0
    }
  }
}
EOF
  # Update openclaw.json to use Google
  cat > /home/node/.openclaw/openclaw.json << 'EOF'
{
  "meta": {
    "lastTouchedVersion": "2026.1.30",
    "lastTouchedAt": "2026-02-06T00:00:00.000Z"
  },
  "gateway": {
    "controlUi": {
      "enabled": true,
      "allowInsecureAuth": true,
      "dangerouslyDisableDeviceAuth": true
    }
  },
  "auth": {
    "profiles": {
      "google:default": {
        "provider": "google",
        "mode": "api_key"
      }
    }
  },
  "agents": {
    "defaults": {
      "model": {
        "primary": "google/gemini-3-flash-preview"
      },
      "workspace": "/workspace",
      "maxConcurrent": 4
    }
  }
}
EOF
fi

# Add OpenAI profile if key is set
if [ -n "$OPENAI_API_KEY" ]; then
  echo "✓ Configuring OpenAI"
  cat > /home/node/.openclaw/agents/main/agent/auth-profiles.json << EOF
{
  "version": 1,
  "profiles": {
    "openai:default": {
      "type": "api_key",
      "provider": "openai",
      "key": "$OPENAI_API_KEY"
    }
  },
  "lastGood": {
    "openai": "openai:default"
  },
  "usageStats": {
    "openai:default": {
      "lastUsed": $(date +%s)000,
      "errorCount": 0
    }
  }
}
EOF
  # Update openclaw.json to use OpenAI
  cat > /home/node/.openclaw/openclaw.json << 'EOF'
{
  "meta": {
    "lastTouchedVersion": "2026.1.30",
    "lastTouchedAt": "2026-02-06T00:00:00.000Z"
  },
  "gateway": {
    "controlUi": {
      "enabled": true,
      "allowInsecureAuth": true,
      "dangerouslyDisableDeviceAuth": true
    }
  },
  "auth": {
    "profiles": {
      "openai:default": {
        "provider": "openai",
        "mode": "api_key"
      }
    }
  },
  "agents": {
    "defaults": {
      "model": {
        "primary": "openai/gpt-4o"
      },
      "workspace": "/workspace",
      "maxConcurrent": 4
    }
  }
}
EOF
fi

echo "✓ OpenClaw config created"

# Start OpenClaw gateway
exec node /app/dist/index.js gateway --allow-unconfigured --bind custom
