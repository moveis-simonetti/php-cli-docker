all: build-php-7.0 build-php-7.1 build-php-7.2

build-php-7.0:
	docker build --pull -t "lojassimonetti/php-cli-docker:php-7.0" -f php7.0/Dockerfile --build-arg http_proxy=${http_proxy} .

build-php-7.1:
	docker build --pull -t "lojassimonetti/php-cli-docker:php-7.1" -f php7.1/Dockerfile --build-arg http_proxy=${http_proxy} .

build-php-7.2:
	docker build --pull -t "lojassimonetti/php-cli-docker:php-7.2" -f php7.2/Dockerfile --build-arg http_proxy=${http_proxy} .