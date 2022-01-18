### TP DNS

> Riboulet Célian S3B"

***

#### 2) DHCP setup on LAN USER machines

In `/etc/network/interfaces` for dns1 dns2 client1 client2

```
iface eth0 inet dhcp
```

All addresses are set by the dhcp server on root

### 3) Adresses

```
dns1 : 192.168.0.1
dns2 : 192.168.0.2
client1 : 192.168.0.10
client2 : 192.168.0.20
```

#### 4) Ping between LAN USER machines

![](./assets/2022-01-04-14-08-42-image.png)

#### 5) Routing tables

![](./assets/2022-01-04-14-09-42-image.png)

---

#### 7) Changing local host name

In **dns1** `/etc/hosts` 

```
192.168.0.2     dns2
192.168.0.10    client1
192.168.0.20    client2
```

#### 8) Ping using  hostname

> From dns1

![](./assets/2022-01-04-14-14-40-image.png)

#### 9) /etc/resolv.conf

> Checking the file on all machines

![](./assets/2022-01-04-14-15-53-image.png)

#### 10) Forcing to use our own dns server

> Editing `/etc/dhcp/dhclient.conf`

On **dns1** and **dns2** :

```
supersede domain-name-servers 127.0.0.1;
```

On **client1** :

```
supersede domain-name-servers 192.168.0.1;
```

On **client2** :

```
supersede domain-name-servers 192.168.0.2;
```

#### 11) Restarting interfaces on all machines

After `ifdown eth0 && ifup eth0` the content of `/etc/resolv.conf` is now :

- for **dns1** and **dns2** :
  
  - ```
    nameserver 127.0.0.1
    ```

- for **client1** :
  
  - ```
    nameserver 192.168.0.1
    ```

- for **client2** :
  
  - ```
    nameserver 192.168.0.2
    ```

#### 12) DNS forwarding

`/etc/bind/named.conf.options` on **dns1** and **dns2** :

![](./assets/2022-01-04-14-31-57-image.png)

#### 13) Configuring primary server (dns1)

> Add add a new dns zone on `/etc/bind/named.conf.loal`

```
zone "netas" {
    type master;
    file "/etc/bind/db.netas";
};
```

#### 14) Filling dns zone file

```
cp /etc/bind/db.empty /etc/bind/db.netas
```

#### 15) Updating zone file header

#### +16) Adding NS entry

`/etc/bind/db.netas`

![](./assets/2022-01-04-14-46-16-image.png)

#### 17) Adding `A` entry

`/etc/bind/db.netas`

![](./assets/2022-01-04-14-49-13-image.png)

#### 18) Restarting the DNS service

```
systemctl restart named
```

> We can also just reload the configuration without having to restart
> 
> ```
> systemctl reload named
> ```

> Check possible errors with :
> 
> ```
> journalctl -u named
> ```

#### 19) Checking status

> To check the service status
> 
> ```
> systemctl status named
> ```

> ![](./assets/2022-01-04-14-53-00-image.png)

#### 20) Ping from client to dns1 using its domain name

> From **client1**

![](./assets/2022-01-04-14-54-52-image.png)

#### 21) Adding `A` entry for dns2

> The file is still  `/etc/bind/db.netas`

![](./assets/2022-01-04-14-59-07-image.png)

Dont forget to increment the Serial number and `systemctl reload named`

#### 22) Adding `CNAME` entries (aliases)

![](./assets/2022-01-04-15-04-11-image.png)

`<increment> Serial + systemctl reload named`

#### 23) Testing config from client

> On **client1**

![](./assets/2022-01-04-15-05-40-image.png)

#### 24) Adding an `NS` entry to identify dns2 as a zone

`/etc/bind/db.netas`

![](./assets/2022-01-04-15-10-13-image.png)

#### 25) Setting up netas as secondary on dns2

> On `/etc/bind/named.conf.local`

```
zone "netas" {
    type slave;
    file "/var/lib/bind/db.netas";
    masters { 192.168.0.1; };
};
```

#### 26) Starting up DNS2 and checking with ping

```
systemctl restart named
```

Then on **client2** :

![](./assets/2022-01-04-15-15-49-image.png)

#### 27) Using `host` command on clients

![](./assets/2022-01-04-15-19-11-image.png)

#### 28) Comparing dns2 and dns1 `db.netas` file

The file on dns2 seams to have the same content as dns1 but in another format (Compressed ?)

#### 29) What is a /22 netmask

A /22 netmask is a mask has 22 bits dedicated to identify the network and the others are used to identify the computer.

192.168.0.(0-255)

192.168.1.(0-255)

192.168.2.(0-255)

192.168.3.(0-255)

#### 30) Scanning the network to get all IPs

On **dns1** :

```
nmap -T5 -sP 10.0.0.0/22
```

![](./assets/2022-01-04-15-34-37-image.png)

#### 31) Connect over ssh to all found IPs

```
ssh tc@<ip>
```

```
10.0.0.254   root
10.0.1.1     a1
10.0.1.2     a2
10.0.2.1     s1
10.0.2.2     s2
10.0.2.3     s3
10.0.3.1     p1
10.0.3.2     p2
```

#### 32) Add an `A` entry for `s1` `s2` and `s3` web servers

`/etc/bind/db.netas`

![](./assets/2022-01-11-14-20-33-image.png)

> Serial number bumped up to 5
> 
> `systemctl restart named`

#### 33) Add a `CNAME` entry for the 3 web servers

![](./assets/2022-01-11-14-25-34-image.png)

**34)** Test from client1 and client2

![](./assets/2022-01-11-14-29-30-image.png)

#### 35) 36) 37) Start web browser on client 1 and then client2

```
startx
```

![](./assets/2022-01-11-14-35-53-image.png)

#### 38) Declaring inverse domain name zone for netas

> `/etc/bind/named.conf.local` on `dns1`

![](./assets/2022-01-11-14-42-28-image.png)

> `/etc/bin/db.netas-rev`

![](./assets/2022-01-11-15-16-27-image.png)

#### 39) Check on client if the reverse domain name is working

> On client2
> 
> ![](./assets/2022-01-11-15-12-59-image.png)

#### 40) Update dns2 configuration

> In order for dns2 to become a secondary server on the reverse netas zone

`/etc/bind/named.conf.local`

![](./assets/2022-01-11-15-24-12-image.png)

#### 41) Testing on client2

![](./assets/2022-01-11-15-24-48-image.png)

> Before and after the setup

#### 42) Add new NS entry to the netas zone (subdomain setup)

![](./assets/2022-01-11-15-32-24-image.png)

#### 43) Declaring the new subdomain

![](./assets/2022-01-11-15-34-19-image.png)

#### 44) Creating zone file

`/etc/dinb/db.perf.netas`

![](./assets/2022-01-11-15-37-27-image.png)

#### 45) Adding A entries for p1 and p2

![](./assets/2022-01-11-15-40-06-image.png)

#### 46) Check on client1

![](./assets/2022-01-11-15-41-35-image.png)

#### 47) Share A between p1 and p2

![](./assets/2022-01-11-15-44-23-image.png)

#### 48) Pingin scale.perf.netas on client1

The pinged IP does change randomly between the p1 and p2 IPs

#### 49) Installing iperf on client1 and client2


