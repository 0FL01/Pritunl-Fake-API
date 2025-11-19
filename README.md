# Simplified Pritunl Fake API Fork

This is a simplified fork of the original Pritunl Fake API that significantly streamlines the setup process.

## What's Changed

- **Simplified Deployment**: The fake API is now hosted directly on the host machine - no separate API server setup required
- **SSL Validation Disabled**: Pritunl's SSL validation has been bypassed to eliminate certificate issues
- **Automatic Activation**: The fake API server is automatically activated on the first Pritunl startup

## Docker Installation (Recommended)

### Option 1: Using Pre-built Images (Fastest)

1. **Clone the repository**:

2. **Start with pre-built images**:
   ```bash
   docker-compose up -d
   ```

3. **Access Pritunl web interface**:
   - Open: https://127.0.0.1:443 (or your server IP)
   - Ignore SSL certificate warnings (self-signed)

4. **Manual activation required**:
   - Login to web interface
   - Enter activation command: `bad premium` or `active ultimate`

### Option 2: Build from Source

1. **Clone repo and prepare**:

2. **Build custom images**:
   ```bash
   # Build Pritunl with fake API integration
   docker-compose build pritunl
   
   # Or build API server separately
   docker-compose build prutunl-api
   ```

3. **Start services**:
   ```bash
   docker-compose up -d
   ```

## Service Architecture

The Docker setup includes three services:

- **pritunl**: Main Pritunl server (privileged, host networking)
- **prutunl-api**: Fake API server (handles license validation)
- **mongo**: MongoDB database for Pritunl

### Port Mapping
- Pritunl Web UI: `https://127.0.0.1:443`
- MongoDB: `127.0.0.1:27017` (internal)
- Fake API: `127.0.0.1:8443` (internal)

### Volume Mapping
- `./pritunl_data:/var/lib/pritunl` - Pritunl configuration
- `./mongo_data:/data/db` - MongoDB data
- `/dev/net/tun:/dev/net/tun` - TUN device for VPN

## Quick Setup

1. **Install Docker and Docker Compose**:

2. **Launch the stack**:
   ```bash
   docker-compose up -d
   ```

3. **Wait for initialization** (2-3 minutes):
   ```bash
   docker-compose logs -f pritunl
   ```

4. **Access and activate**:
   - Navigate to https://127.0.0.1:443
   - Complete initial setup wizard
   - Use activation command: `bad premium` or `active ultimate`

## Troubleshooting

### Common Issues
- **SSL Certificate Warnings**: Expected with self-signed certificates
- **MongoDB connection failed**: Ensure MongoDB container is running

## Original Repository

<details>
<summary>Click to view original repository description</summary>

# What is this? #
This neat script provides a little fake API to unlock all premium/enterprise/enterprise+ (here called ultimate) features of your own Pritunl VPN server. If Pritunl wouldn't be mostly free already, you could call this a crack. An Open Source crack.

## How to setup (server) ##
Take a look into the `server` folder: You _could_ use the Pritunl source there (or just download this specific version from their GitHub repo) to compile a guaranteed compatible version for this API or just download any other version of the Pritunl server and try your luck.
Then you'll need to execute the `setup.py` script (preferable as `root`, as it needs to modify the Pritunl files directly).
After that log in into the dashboard - there should be a "Update Notification":

![login-msg](docs/login-msg.png)

Now try to enter any serial key for your subscription and just follow the hints/notes if you enter an invalid command:

![enter-something](docs/enter-something.png)

A valid command would be `bad premium` or `active ultimate`:

![active-ultimate](docs/active-ultimate.png)

If everything worked, your subscription should now look like this:

![done](docs/done.png)

Make sure to support the developers by buying the choosen subscription for your enterprise or company!

## How to setup (api) (optional) ##
This is _optional_. You can simply use the default instance of this API (host is noted inside the `setup.py` script) and profit from "automatic" updates.

## API Only: Using Apache
Just transfer the `www` files inside a public accessible root-folder on your _dedicated_ Apache webserver (really everthing with PHP support works). Also make sure your instance has a valid SSL-certificate (Let's encrypt is enough), otherwise it may won't work.
An example Apache install process can be found [here](docs/apache/install.md). If you want to test your instance, just open the public accessible URI in your browser and append `/healthz` to it - if you see some JSON with the text, then everything worked!

### API Only: Using Nginx
Just transfer the `www` files inside a public accessible root-folder on your _dedicated_ Nginx webserver (really everthing with PHP support works). Also make sure your instance has a valid SSL-certificate (Let's encrypt is enough), otherwise it may won't work.
See the documentation in [Nginx Install](docs/nginx/install.md).

### API Only: Using Docker
See the documentation in [Docker Install](docs/docker/api-only-install.md).

### Fully Patched Pritunl: Using Docker
This api has also its own docker image. Take a look into the `docker` folder and enjoy!

See the documentation in [Patched Pritunl Docker Install](docs/docker/pritunl-patched-install.md).

### Nett2Know ###
* This modification will also block any communication to the Pritunl servers - so no calling home :)
* SSO will not work with this api version! As Pritunls own authentication servers handle the whole SSO stuff, track instance ids and verify users, I won't implement this part for privacy concerns (and also this would need to be securly implemented and a database).

Have fun with your new premium/enterprise/ultimate Pritunl instance!

</details>

## Support

Please support the original Pritunl developers by purchasing a subscription for your enterprise or company if you find this tool useful!
