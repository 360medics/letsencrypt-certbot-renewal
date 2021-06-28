# letsencrypt-certbot-renewal

This script is a standalone shell script to renew a SSL certificate issued by letsencrypt and certbot with the "standalone" mode without having to stop Nginx. It can be easily programmed from a crontab to save you the hassle of renewing certificates by hand.

## Requirements

Nginx, Bash, [certbot](https://certbot.eff.org/). Written for Debian machines. Should work in any bash environments, but only tested on Debian 8,9,10

## Which problems does that script solves ?

- Stopping Nginx to renew certificates
- Auto-renewing certificate because basic install does not do it. God knows why.

## Behind the hood

Current strategy: we use the `./well-known` vhost location to renew a Nginx certificate and the [ACME challenge](https://letsencrypt.org/docs/challenge-types/).

Letsencrypt just writes a file with a token in it into the directory where `./well-known` points in your virtual host and the ACME server tries to `GET` the file: `/.well-known/acme-challenge/<TOKEN>`. If this succeed, this validates the authenticity of the domain and website.

Thus the following Nginx configuration is required (for each vhost/domain to renew): 

```
location ~ /\.well-known {
    # obviously this directory will be passe to the certbot command so that it knows
    # where to put the file. (mkdir -p /var/www/html/letsencrypt if you aint got it)
    root /var/www/html/letsencrypt;
}
```

## Download & install

```
curl -O https://raw.githubusercontent.com/360medics/letsencrypt-certbot-renewal/master/certbot-renew.sh

# optional: make it availbale and executable globally as a command
sudo mv certbot-renew.sh /usr/local/bin/certbot-renew
chmod +x /usr/local/bin/certbot-renew

# test
certbot-renew
```

## Usage

```
certbot-renew hello-world.com,www.hello-world.com,other-domain.com
```

Your are now free to create a crontab each month to launch the script.

