# Scanning Errors

A Scan was run using the Zap open source tool, using the following command:
```
docker run -v $(pwd):/zap/wrk/:rw -t owasp/zap2docker-stable zap-full-scan.py     -t http://xk3r.hatchboxapp.com/ -r testreport.html -J heimdall_zap.json
```

It produced a small number of warnings, none of them serious and a few false positives.

## Low Level Issues

### Server Leaks Information via "X-Powered-By" HTTP Response Header Field(s)
Nginx/Passenger set the X-Powered-By header to "Phusion Passenger 6.0.3". On Hatchbox.io, it's not currently possible for us to remove headers. We can add headers, but in order to remove them, Nginx has to be compiled with a headers package that adds some header manipulation settings.

It's considered bad practice to broadcast how production sites are being served, but considering it is almost always Nginx/Passenger or Apache/Passenger, the information is not really that sensitive.

### Cookie Without SameSite Attribute
SameSite is a new header attribute used for CSRF protection. Chrome and FireFox support it, but Safari doesn't - yet. The scan flagged a few instances of this. It may be possible to set this - it would take some research and testing, but Rails already has CSRF protection by default.

## False Positives

### A timestamp was disclosed by the application/web server - Unix
In scanning compressed a Javascript files it came across a bunch of numbers that it interprets as timestamps. The numbers are actually the decimal values of a RGB colors.

### Application Error Disclosure
The scan is flagging the Rails standard production error page, claiming it (may) expose information. It doesn't. The page displays a banner saying an error occurred, but shows no details. The error is logged on the server but no details about the error are shown to the user.

## Information Disclosure - Suspicious Comments
The scan is complaining about a what I would consider 'Helpful' comments in the application javascript file, comments that explain what particular lines do.
