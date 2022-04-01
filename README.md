# Nebula Debian Docker Images

Immagine docker Nebula

### Prerequisiti

- Se si usa il comando rapido, l'immagine non ha prerequisiti.
- Make deve essere installato sulla macchina host per poter utilizzare il makefile:
  ```
  sudo apt install make
  ```

### Recupero del file di configurazione

```
docker run --rm ghcr.io/manprint/nebula:1.5.2 cat /root/nebula/config/config.example.yml > config.example.yml
```

### Avvio Rapido

```
@docker run -dit \
	--name=nebula \
	--hostname=nebula-srv \
	--cap-add=NET_ADMIN \
	--network=host \
	--volume=/path/to/config.yml:/root/nebula/config/config.yaml:ro \
	--volume=/path/to/ca.crt:/root/nebula/certs/ca.crt:ro \
	--volume=/path/to/host.crt:/root/nebula/certs/host.crt:ro \
	--volume=/path/to/host.key:/root/nebula/certs/host.key:ro \
	ghcr.io/manprint/nebula:1.5.2
```

#### File da montare

- config.yml: file di configurazione di nebula
- ca.crt: nebula certificatation autority
- host.crt: nebula host certificate
- host.key: nebula host private key

Nota bene: i path interni al container per il set di chiavi è definito nel file di configurazione. Nel caso si dovessero modificare, modificare anche il run in accordo.

### Gestione container tramite makefile

- Scaricare il makefile:
  ```
  curl -sSL https://raw.githubusercontent.com/manprint/nebula-debian/main/Makefile
  ```

- Eseguire il comando `make` per vedere i task disponibili
- Modificare il makefile se è necessario secondo le proprie esigenze

### Connessione al container

```
docker exec -it nebula bash -l
```