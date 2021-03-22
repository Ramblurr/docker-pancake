PANCAKE_LICENSE ?= $(shell secret-tool lookup Path '/PancakeApp - License')
download:
	curl http://manage.pancakeapp.com/download/${PANCAKE_LICENSE} > pancake.zip

build:
	podman build -t docker-pancake:latest .

prepare:
	podman run -v /data/pancake:/var/www/html --rm docker-pancake:latest /opt/download-pancake.sh

