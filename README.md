# iii
https://iii.dev/docs/install

## caddy
```
iii.feg.cn {
    handle /api/* {
        reverse_proxy 127.0.0.1:3111
    }
    handle /stream/* {
        reverse_proxy 127.0.0.1:3112
    }
    handle /ws {
        reverse_proxy 127.0.0.1:49134
    }
    handle {
        reverse_proxy 127.0.0.1:3111
    }
}
```

## nginx
```
server {
    listen 443 ssl;
    server_name iii.feg.cn;

    location /api/ {
        proxy_pass http://127.0.0.1:3111;
    }

    location /ws {
        proxy_pass http://127.0.0.1:49134;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }

    location /stream/ {
        proxy_pass http://127.0.0.1:3112;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }

    location / {
        proxy_pass http://127.0.0.1:3111;
    }
}
```
