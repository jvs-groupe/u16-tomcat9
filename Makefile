# Si besoin à remplacer le nom de l'utilisateur docker final
DOCKER_USER=jvsgroupe

# Map de port, si le 8080 est déjà pris
PORT:=127.0.0.1:8080

# Nom du container
NAME:=u16_tomcat9

# Chemin courant = real_path
ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

# Ip Host
LOCAL_HOST:=${shell hostname --ip-address 2> /dev/null || (ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p' | awk '{print $1; exit}')}

# Id, ... de docker
RUNNING:=$(shell docker ps | grep $(NAME) | cut -f 1 -d ' ')
ALL:=$(shell docker ps -a | grep $(NAME) | cut -f 1 -d ' ')

# Options de la ligne de commande
DOCKER_RUN_COMMON=--name="$(NAME)" -p $(PORT):8080 $(DOCKER_USER)/$(NAME)

# Par défaut le build
all: build

# Compilation de l'image
build: clean
	mkdir -p $(ROOT_DIR)/docker-logs
	docker build -t="$(DOCKER_USER)/$(NAME)" .

# Démarrage du container
run: clean
	mkdir -p $(ROOT_DIR)/docker-logs
	docker run -d $(DOCKER_RUN_COMMON)

# Arrêt du container
stop: clean

# Démarrage d'un bash sur le container
bash: clean
	mkdir -p $(ROOT_DIR)/docker-logs
	docker run -t -i $(DOCKER_RUN_COMMON) /bin/bash

# Push to registry
push: build
	docker tag $(shell docker images -q $(DOCKER_USER)/$(NAME)) $(DOCKER_REGISTRY)/$(NAME)
	docker push $(DOCKER_USER)/$(NAME)
	docker rmi --force $(shell docker images -q $(DOCKER_USER)/$(NAME))

# Supprime les containers existants
clean:
ifneq ($(strip $(RUNNING)),)
	docker stop $(RUNNING)
endif
ifneq ($(strip $(ALL)),)
	docker rm $(ALL)
endif

# Nettoyage complet !!!
deepclean: clean
	rm -rf $(ROOT_DIR)/docker-logs
