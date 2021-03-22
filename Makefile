PANCAKE_LICENSE ?= $(shell secret-tool lookup Path '/PancakeApp - License')
download:
	curl http://manage.pancakeapp.com/download/${PANCAKE_LICENSE} > pancake.zip

build:
	podman build -t pancake-private:latest .
