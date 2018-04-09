VERSION := $(shell cat modules.yml | grep version | head -n 1 | awk  '{ gsub("\"", ""); print $2 }')

build:
	docker build . -t nginx-custom
	docker run -v `pwd`/result:/result  nginx-custom 
