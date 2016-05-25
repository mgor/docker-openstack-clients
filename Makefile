NAME = mgor/openstack-clients
HOSTNAME = openstack-client
DOCKER_OPTS =

.PHONY = all build run

all: build run

build:
	docker build -t $(NAME) .

set_opts_openrc: 
ifneq ($(openrc),)
	$(eval DOCKER_OPTS += -v $(openrc):/root/$(notdir $(openrc)))
else
	$(foreach _openrc,$(wildcard *openrc), $(eval DOCKER_OPTS += -v $(CURDIR)/$(_openrc):/root/$(_openrc))) 
endif

set_opts_cafile:
ifneq ($(cafile),)
	$(eval DOCKER_OPTS += -v $(cafile):/etc/ssl/certs/$(notdir $(cafile)))
else
	$(foreach _cafile,$(wildcard *.crt), $(eval DOCKER_OPTS += -v $(CURDIR)/$(_cafile):/etc/ssl/certs/$(_cafile)))
endif

run: set_opts_openrc set_opts_cafile
	docker run --rm --name $(HOSTNAME) --hostname $(HOSTNAME) -e OS_PROXY=$(proxy) $(DOCKER_OPTS) -it $(NAME)
