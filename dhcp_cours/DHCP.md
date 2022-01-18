Unicast : destinataire unique
Broadcast : envoie à tous ceux qui partagent le réseaux

# Dynamic Host Configuration Protocol

(Arriver au milieu de la section 5 pour le tp)

La configuration d'une machine :
- Connexion au réseau local
    - addr ip
    - masque de sous réseau
    - infos de routage (passerelle)

- Connaissance des services
    - adresse serveurs de noms (DNS), de temps (NTP), d'impression, etc...

- Informations diverses
    - Nom de la machine, nom de réseau, etc...

- Options avancés
    - Systeme a charger (PXE)


Cette configuration est soit fixées en dur
    - Fichier de conf

Soit fournies par un serveur à la demande (à chaque démarrage)
    - Configuration dynamique (DHCP)

# DHCP

Permet à des machines "clientes" de recevoir automatiquement leurs paramètres de configuration réseau l'orsquelle se connectent sur un réseau local

Interet :
- Centralier au sein d'un réseau.
- Modifications uniquement sur le serveur.
- Chaque client en bénéficie au prochain démarrage.

### Allocation d'adresse IP

- 1 une machine démarre
    - Elle envoie une requête DHCP en broadcast
- 2 le serveur DHCP répond à l'adresse MAC du client en fournisant :
    - une adresse IP
    - info réseau (Masque, passerelle, etc..)

### 2 méthode d'alloc

- Statique
    - adresse IP réservée associé par l'admin à une adresse MAC spécifié
    (Le serveur donne toujours la même IP)

    Utilisée quand la plage d'adresse IP < au nb client potentiels (Ex : wifi chez soi)

- Dynamique
    - plage d'adresse reservée, accordée aux nouvelles machines, avec un bail (lease), renouvelable sur demande
    - Le serveur retient l'asssociation @MAC/@IP du client pour lui fournir la même config à la prochaine requête pour un temp donné
    (Le serveur ne donne pas forcement toujours la mm IP)

    Les adresses doivent être libérés
    - Le client doit libérer le bail en partant
    - Le bail a une durée fixée par le serveur (lease-time)
    - Le client doit renouveler son bail avant expiration

On peut resteindre l'accès au DHCP avec une blacklist d'adresse MAC

### Détail du Protocol DHCP

Protocol de couche Application

Client : Port 68

Serveur : Port 67

__Allocation__
- Machine : Envoie message DHCP : DISCOVER (en *broadcast*)
- Serveur DHCP : Répond avec : OFFER (en *unicast*)
- Machine : demande le bail : REQUEST (en *broadcast*)
- Serveur DHCP : Accepte le bail : ACK (en *unicast*)

__Renouvellement__
__à 50% du temps__
- Machine : demande le bail : REQUEST (en *unicast*)
- Serveur DHCP : Accepte le bail : ACK (en *unicast*)

__à 87.5% du temps__
- Machine : demande le bail : REQUEST (en *broadcast*)
- Serveur DHCP : Accepte le bail : ACK (en *unicast*)

__Libération__
- Machine : libère l'ip : RELEASE (en *unicast*)

#### Messages

DHCPDiscover
DHCPOffer
DHCPRequest
ACK

### Trames Discover
```
Ethernet :
- @MAC source de la trame MAC
- @MA destination de la trame MAC

IP :
- @IP source du datagramme IP (0.0.0.0)
- @IP destination du datagramme IP (255.255.255.255)

UDP :
- PORT 68 client
- PORT 67 serveur
```
### Diffusion

- Boradcast : diffusion de la requete DHCP à tous les postes connectés
    - ADDR Mac de diffusion ff:ff:ff:ff:ff:ff
    - ADDR IP de diffusion générique : 255.255.255.255
        - Tous les routeurs comprennent que ces adresses correspondent à un boradcast, donc ils retransmettent le msg à tous les membres du réseau


### Trames DHCPOffer
```
IP :
- @IP du routeur
- @IP que le routeur propose au client

Port :
- 67
- 68
```
### Trames DHCPRequest
```
IP :
- @IP que le client veut accepter
- @IP du routeur

Port :
- 68
- 67
```
### Config serveur

```/etc/dhcp/dhcpd.conf```

### Compléments


