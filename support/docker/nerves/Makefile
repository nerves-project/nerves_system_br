REPO=nervesproject/nerves

build:
	docker build --rm -t ${REPO} .

push:
	docker push ${REPO}:$(shell cat ../../../VERSION)

run:
	docker run --rm -it ${REPO}

.PHONY: build push
