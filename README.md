# Conteneur Tomcat 9 -- Java 8
---

## Description

Ce conteneur permet d'avoir un serveur Tomcat avec Java 8. Il suffit de mapper le port 8080 vers un port local.

## Configuration

Par défaut on garde le port standard 8080.

## Build

Il suffit d'utiliser le makefile

```
    // Générer le build
	make build
	
	// Lancer le conteneur
	make run
	
	// Accéder en bash
	docker exec -it u16_tomcat9 /bin/bash
	
	// Accès direct en shell sans daemon
	make bash 
```
