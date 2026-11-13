\# Schéma réseau



```mermaid

flowchart TB

&#x20;   INTERNET((Internet))

&#x20;   INTERNET ---|Carte NAT VirtualBox| RTR01



&#x20;   RTR01{{"RTR01<br/>Routeur / pare-feu Debian<br/>(.1 dans chaque zone)"}}



&#x20;   subgraph SRV\["Zone Serveurs — 10.50.10.0/24 — lab-srv"]

&#x20;       DC01\["DC01<br/>AD DS, DNS, DHCP, NTP<br/>10.50.10.11"]

&#x20;       DC02\["DC02<br/>AD DS, DNS<br/>10.50.10.12"]

&#x20;       FS01\["FS01<br/>Serveur de fichiers<br/>10.50.10.20"]

&#x20;       BK01\["BK01<br/>Sauvegarde<br/>10.50.10.30"]

&#x20;   end



&#x20;   subgraph ADM\["Zone Administration — 10.50.99.0/24 — lab-admin"]

&#x20;       ANSIBLE01\["ANSIBLE01<br/>Contrôleur Ansible<br/>10.50.99.10"]

&#x20;       PCINFO\["PC-INFO-01 à 05<br/>DHCP .100 – .149"]

&#x20;   end



&#x20;   subgraph COMPTA\["Zone Comptabilité — 10.50.20.0/24 — lab-compta"]

&#x20;       PCCOMPTA\["PC-COMPTA-01 à 15<br/>DHCP .100 – .199"]

&#x20;   end



&#x20;   subgraph RH\["Zone RH — 10.50.30.0/24 — lab-rh"]

&#x20;       PCRH\["PC-RH-01 à 05<br/>DHCP .100 – .199"]

&#x20;   end



&#x20;   subgraph USERS\["Zone Autres utilisateurs — 10.50.40.0/24 — lab-users"]

&#x20;       PCUSERS\["PC-DIR-01 à 05<br/>PC-COM-01 à 10<br/>PC-OPS-01 à 10<br/>DHCP .100 – .199"]

&#x20;   end



&#x20;   RTR01 ---|10.50.10.1| SRV

&#x20;   RTR01 ---|10.50.99.1| ADM

&#x20;   RTR01 ---|10.50.20.1| COMPTA

&#x20;   RTR01 ---|10.50.30.1| RH

&#x20;   RTR01 ---|10.50.40.1| USERS



&#x20;   ANSIBLE01 -.->|SSH / WinRM| SRV

```



\*\*Légende\*\*

\- Trait plein : lien réseau entre RTR01 et une zone (passerelle indiquée sur le trait).

\- Pointillé : flux d'administration Ansible.

\- Les flux autorisés en détail sont dans \[flux-autorises.md](flux-autorises.md).

