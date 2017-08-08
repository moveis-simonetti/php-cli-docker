build:
	docker build -t "lojassimonetti/php-cli-docker" . --build-arg http_proxy=${http_proxy}
