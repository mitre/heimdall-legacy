* Nginx Configuration

This conf file is used on http://xk3r.hatchboxapp.com. It differs slightly from the default conf file, adding several security headers.

```
%{upstream}

add_header X-XSS-Protection "1; mode=block";

server {
  listen 80;
  listen [::]:80;

  server_name %{domains};
  root %{root};

  %{server_config}

  # Allow uploads up to 100MB in size
  client_max_body_size 100m;
  add_header X-Content-Type-Options "nosniff" always;
  add_header X-XSS-Protection "1; mode=block" always;
  add_header X-Robots-Tag none;

  location ~ ^/(assets|packs) {
    expires max;
    gzip_static on;
    add_header Cache-Control "max-age=0, private, must-revalidate";
    add_header X-Frame-Options SAMEORIGIN;
	  add_header X-Content-Type-Options "nosniff" always;
  }

  error_page 404 500 502 503 504 = /error.html;
  location = /error.html {
    root /var/www/html/hatchbox;
  }

  location = /robots.txt {
    add_header X-Content-Type-Options "nosniff" always;
    allow all;
    log_not_found off;
    access_log off;
  }
}
```
