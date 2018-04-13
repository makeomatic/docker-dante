Dante - A free SOCKS server
===========================

[Dante][1] is a product developed by Inferno Nettverk A/S. It consists of a
SOCKS server and a SOCKS client, implementing RFC 1928 and related standards.
It is a flexible product that can be used to provide convenient and secure
network connectivity.

## sockd.conf

```
debug: 0
logoutput: stderr
internal: 0.0.0.0 port = 1080
external: eth0
socksmethod: username none
clientmethod: none
user.privileged: root
user.unprivileged: nobody

client pass {
  from: 0.0.0.0/0 port 1-65535 to: 0.0.0.0/0
  log: error
}

socks pass {
  from: 0.0.0.0/0 to: 0.0.0.0/0
  socksmethod: username
  log: error
}
```

## up and running

```
$ SOCKS_USERNAME=username SOCKS_PASSWORD=password docker-compose up -d
$ curl -x socks5h://username:password@127.0.0.1:1080 https://www.youtube.com
```

[1]: http://www.inet.no/dante/index.html
