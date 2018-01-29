# Alpine Linux Docker image for ARM devices

This ruby script downloads the latest stable Alpine Linux `minirootfs` release and creates a Docker image.

> **Note**: this script is discontinued. If you want to use ARM images on Docker with great support and enhancements, check out [Resin.io](https://resin.io) [images](https://hub.docker.com/u/resin/).

## Usage

```bash
$ git clone https://github.com/cgrs/docker-alpine-armhf.git
$ bundle install
$ ./update-image.rb
```

## License

[MIT License](https://mit-license.org)
