# Singbox + VLess + Reality

I'll help you configure sing-box with VLess+Reality. This is a modern proxy protocol that provides better censorship resistance.

## Basic Configuration Structure

You'll need both a **server** and **client** configuration. Here's how to set them up:

### Server Configuration

```json
{
  "log": {
    "level": "info"
  },
  "inbounds": [
    {
      "type": "vless",
      "tag": "vless-in",
      "listen": "::",
      "listen_fields": {
        "tcp_fast_open": true
      },
      "sniff": true,
      "sniff_override_destination": false,
      "domain_strategy": "prefer_ipv4",
      "users": [
        {
          "uuid": "YOUR-UUID-HERE",
          "flow": "xtls-rprx-vision"
        }
      ],
      "tls": {
        "enabled": true,
        "server_name": "www.example.com",
        "reality": {
          "enabled": true,
          "handshake": {
            "server": "www.example.com",
            "server_port": 443
          },
          "private_key": "YOUR-PRIVATE-KEY",
          "short_id": ["YOUR-SHORT-ID"]
        }
      }
    }
  ],
  "outbounds": [
    {
      "type": "direct",
      "tag": "direct"
    }
  ]
}
```

### Client Configuration

```json
{
  "log": {
    "level": "info"
  },
  "inbounds": [
    {
      "type": "mixed",
      "tag": "mixed-in",
      "listen": "127.0.0.1",
      "listen_port": 1080
    }
  ],
  "outbounds": [
    {
      "type": "vless",
      "tag": "proxy",
      "server": "YOUR-SERVER-IP",
      "server_port": 443,
      "uuid": "YOUR-UUID-HERE",
      "flow": "xtls-rprx-vision",
      "tls": {
        "enabled": true,
        "server_name": "www.example.com",
        "utls": {
          "enabled": true,
          "fingerprint": "chrome"
        },
        "reality": {
          "enabled": true,
          "public_key": "YOUR-PUBLIC-KEY",
          "short_id": "YOUR-SHORT-ID"
        }
      }
    }
  ]
}
```

## Key Steps to Configure

1. **Generate UUID**: Use `sing-box generate uuid` or any UUID generator

2. **Generate Reality keypair**:
   ```bash
   sing-box generate reality-keypair
   ```
   This gives you a private key (for server) and public key (for client)

3. **Generate Short ID**:
   ```bash
   sing-box generate rand --hex 8
   ```

4. **Choose a destination website** (`server_name` and `handshake.server`): Pick a popular TLS website (like www.apple.com, www.microsoft.com, etc.) that supports TLS 1.3

5. **Important parameters to match**:
   - UUID must be identical on server and client
   - Server name must match between server/client
   - Private key on server, public key on client (they're a pair)
   - Short ID must match

## Running sing-box

```bash
# Start server
sing-box run -c server.json

# Start client
sing-box run -c client.json
```

The client will create a local proxy on `127.0.0.1:1080` that you can use in your applications.

## Default Configuration Paths

sing-box looks for configuration files in these locations (in order):

1. **Linux/macOS**:
   - `$XDG_CONFIG_HOME/sing-box/config.json` (if XDG_CONFIG_HOME is set)
   - `~/.config/sing-box/config.json` (default XDG location)
   - `/etc/sing-box/config.json` (system-wide)

2. **Windows**:
   - `%APPDATA%\sing-box\config.json`

## Usage

If you place your config in one of these default locations, you can simply run:

```bash
sing-box run
```

Without the `-c` flag, and it will automatically find your config file.

## Recommended Setup

For a client configuration, I'd recommend:

```bash
# Create the config directory
mkdir -p ~/.config/sing-box

# Place your client config there
nano ~/.config/sing-box/config.json

# Run without specifying the path
sing-box run
```

## Running as a Service

If you want to run it as a systemd service, the typical setup uses `/etc/sing-box/config.json`:

```bash
sudo mkdir -p /etc/sing-box
sudo nano /etc/sing-box/config.json
```

Then create a systemd service file at `/etc/systemd/system/sing-box.service`:

```ini
[Unit]
Description=sing-box service
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/sing-box run -c /etc/sing-box/config.json
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

So yes, you can just place it in `~/.config/sing-box/config.json` and run without arguments!
