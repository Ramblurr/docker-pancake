# pancake docker

A docker image for [Pancake](https://www.pancakeapp.com).

Based on the [Nextcloud PHP Apache dockerfiles](https://github.com/nextcloud/docker).


## Usage

1. Download your licensed copy of pancake to the local dir named `pancake.zip`

        curl http://manage.pancakeapp.com/download/${PANCAKE_LICENSE} > pancake.zip

2. Build the image

        docker build -t pancake-private:latest .


3. Run the image

        mkdir ./test-vol
        podman run -it --rm -p 8001:80 -v $(pwd)/test-vol:/var/www/html pancake-private:latest


