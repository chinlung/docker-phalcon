# Phalcon Docker image

The repository is a Docker image based on [php]:[5.6-apache] with a base configuration of Phalcon framework. Phalcon is compiling from source, version is defined by environment variable.

Image is updated via pull requests to the [chinlung/docker-phalcon] GitHub repo.

Learn more about the framework at Phalcon's [official website].

## How to use it

### Without Dockerfile

If you do not want to include a Dockerfile in your project, it is sufficient to do the following:

```sh
$ docker run -d -p 80:80 --name my-phalcon-app -v "$PWD/src":/var/www/html -v "$PWD/apache":/etc/apache2/sites-enabled chinlung/docker-phalcon
```

Where `src` is the directory containing all your PHP code, and `apache` is the directory containing Apache Virtual Host configuration files.

### With Dockerfile

```sh
# Dockerfile
FROM chinlung/docker-phalcon
COPY src/ /var/www/html/
COPY my-apache.conf /etc/apache2/sites-enabled/000-default.conf
```

Where `src` is the directory containing all your PHP code, and `my-apache.conf` is an Apache Virtual Host configuration file.

Then, run the commands to build and run the Docker image:

```sh
$ docker build -t my-phalcon-app .
$ docker run -d -p 80:80 --name my-running-app my-phalcon-app
```

### Environment variables

- `APACHE_LOG_DIR` - directory name to store Apache logs (default: /var/log/apache2).
- `PHALCON_TAG` - tag name in [phalcon/cphalcon] Git repository (default: phalcon-v2.0.13).

[official website]: https://phalconphp.com
[php]: https://hub.docker.com/_/php/
[5.6-apache]: https://github.com/docker-library/php/blob/47abb34bbfc92ccd26d07351bc18542ded37ef17/5.6/apache/Dockerfile
[chinlung/docker-phalcon]: https://github.com/chinlung/docker-phalcon
[phalcon/cphalcon]: https://github.com/phalcon/cphalcon/releases
