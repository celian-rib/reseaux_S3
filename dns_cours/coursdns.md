## Domain. Name. Server. Cours

> Composant vital d'internet



### 1/ Principes

#### Objectifs :

- Ne pas avoir à retenir les adresse IP

- Nommer les ressources sur internet

Résolution de noms :

> Numéro IP de www.labri.fr ?

Résolution inversée

> Qui a l'adresse IP 192....

#### Solution actuelle

- Système hiérarchisé réparti sur des centaines de milliers de serveurs DNS

L'espace des nom est stucturé

`info-ssh1.iut.u-bordeaux.fr` 

        fait partie du du **domain zone** `iut.u-bordeaux.fr`

        qui est un **sous domaine** de ```u-bordeaux.fr``` 

        qui est dans le **top-level domain** ```.fr```    

        qui est enfant direct de la racine



le service DNS est décentralisé au niveau pkéntaire

A tout domain est associé une organisation la gérant

Il existe 13 serveurs racine dans le monde + 130 serveurs de backup

#### Rôles des Serveurs DNS

- Enregistrer les données propres à une zone

- Répondent aux requêtes concernant leur zone d'autorité

- Transmettre les requêtes auxquelles ils ne peuvent pas répondre à un autre serveur DNS

> Les serveur sont interconnectés, si ils ne connaissent pas une adresse ils redirigent vers un serveur qui **pourrait** la connaître



#### Host

La commande `host` permet d'intérroger un DNS

```
$ host www.google.fr
```

```
$ host ent.u-bordeaux.fr

ent.u-bordeaux.fr is an alias for v-frtent01.u-bordeaux.fr.
v-frtent01.u-bordeaux.fr has address 147.210.215.13

```

> Ici le nom est un alias vers un autre nom de domaine

```
$ host u-bordeaux.fr

u-bordeaux.fr has address 147.210.215.26
u-bordeaux.fr mail is handled by 10 mta-in03.u-bordeaux.fr.
u-bordeaux.fr mail is handled by 10 mta-in02.u-bordeaux.fr.
u-bordeaux.fr mail is handled by 10 mta-in04.u-bordeaux.fr.
u-bordeaux.fr mail is handled by 10 mta-in01.u-bordeaux.fr.
```

A chaque nom sont associées divers “enregistrements” (records).

```
$ host -t MX google.fr


google.fr mail is handled by 0 smtp.google.com.
```

`host -t MX google.fr` pour les échangeurs de courrier

`host -t A google.fr` adresses IPv4

`host -t AAAA google.fr` adresses IPv6



#### Résolution inverse

Pour trouver un nom de domaine à partir d'une IP

```
$ host 147.210.94.20
20.94.210.147.in-addr.arpa domain name pointer ord-trasi.iut.u-bordeaux.fr.
```



#### Zones

Les informations sur une zone sont détenues par un serveur maitre et quelques esclaves.

- redondance : résistance aux panne.

- L'administrateur de la zone modifie les infos du serveur maître qui fait autorité.

- Les serveurs esclaves sont mis à jour automatiquement.



Problème envisagés

- serveur en panne

- coupure / isolation réseau

Donc il faut des serveurs esclaves en dehors du réseau de l'institution.

- Hébergeur professionel

- Convention avec autres institutions

- Arrangements entre administrateurs pour hébrgements réciproques (Ex : universités)



Chaque zone

- est décrite par des serveurs (Mâitres et esclaves)

- connaît les serveur des sous-domaines

> La zone `.fr`  contient le nom `u-bordeaux.fr` et les serveurs de noms qui s'en occupe



### 2/ Résolution

#### Que fait le serveur intérrogé ?

Ca depend de sa config :

- S'il connait la réponse
  
  - Car il a l'info en cache
  
  - Car il est le serveur de la zone concerné

- Il pose la question à un autre serveur



#### Résolution itérative

Le client requete le serveur racine qui lui répond le serveur de zone (.fr) qui lui reponde le serveur de domaine qui lui répond l'adresse IP finale



#### Cache

Garder en mémoire les adresses très demandées pour gagner du temps

Compromis à trouver entre :

- durer de vie du cache
  
  - long = diminution nb requêtes
  
  - courte = données pas trop périmées
  
  - typiquement 1 jour



#### Chaines de mandataire

Dans les organisations d’une certaine importance, il peut êtreintéressant de chaîner les mandataires. Par exemple

- DNS du dep info
  
  - DNS de l'iut
    
    - DNS de l'université

Les réponses récupérées à l'extérieur sont centralisées et misent en commun

- Limitation du traffic vers l'extérieur

- Réponses plus rapides





***



Les serveurs DNS ont plusieurs fonctions

- détenir les infos pour une zone

- répondre aux clients (requêtes récursives)

- relayer les requêtes (forwarding)

- mémoriser les réponses (cache)

- faire la résolution (itérative)...



Selon leur rôle dans le réseau, ces fonctions sont activées ou non.

- relais : se contente de retransmettre à un autre serveur

- simple mandataire (ne gère de zone)

- gros serveur de zones (ne traite pas les requêtes récursives)



Résolution des problèmes de résistance aux pannes :

- une zone est gérée par plusieurs serveurs
  
  - un serveur maître
  
  - des serveurs esclaves



Quand l'administrateur modifie une zone sur le serveur maître

- Le serveur maître contacte es esclaves pour leur envoyer une copie

- Les serveur esclaves interroge périodiquement le serveur maître
  
  - il demande numéro de version
    
    - si le numéro ne correspond pas il demande le transfert de la dernière version pour s'update
    
    - Si il n'arrive pas a joindre le maître il rééssai



#### Configuration client

`/etc/resolve.conf`

```
search maison.net
domain maison.net
nameserver 10.4.2.254
```

#### Configuration serveur

`etc/bind/named.conf` ou `/etc/bind/named.conf.local`

```
zone  "maison.net " {
    type master;
    file "/etc/bind/db−maison.net";
};

zone  "2.4.10.in−addr.arpa " {
    type master;
    file"/etc/bind/db−2.4.10";
};
```

#### Piéges courant

- points au bout des noms complètement qualifiés
  
  `truc IN A 10.1.1.1`
  
  `www IN CNAME machin.chose.com.`

- ne pas oublier la résolution inverse

- numéro de version
  
  - année mois jour sur 8 chiffres
    
    - `2015101905` version 5 du 19 octobre 2015. 
      
      On fait rarement plus de 99 versions par jours






