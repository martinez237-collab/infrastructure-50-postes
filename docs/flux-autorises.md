\# Matrice des flux autorisés



Politique par défaut du pare-feu RTR01 : \*\*tout est bloqué et journalisé\*\*, sauf les flux listés ci-dessous.



Zones utilisateurs = Comptabilité, RH, Autres utilisateurs.



\## Flux autorisés



| # | Source | Destination | Protocole / Port | Usage |

| --- | --- | --- | --- | --- |

| 1 | Zones utilisateurs | DC01, DC02 | TCP/UDP 53 | DNS |

| 2 | Zones utilisateurs | DC01, DC02 | TCP/UDP 88, 464 | Kerberos, changement de mot de passe |

| 3 | Zones utilisateurs | DC01, DC02 | TCP/UDP 389, TCP 636, TCP 3268 | LDAP, LDAPS, catalogue global |

| 4 | Zones utilisateurs | DC01, DC02 | TCP 445 | SYSVOL / NETLOGON (GPO, scripts) |

| 5 | Zones utilisateurs | DC01, DC02 | TCP 135, TCP 49152–65535 | RPC (jonction au domaine, GPO) |

| 6 | Zones utilisateurs | DC01 | UDP 123 | Synchronisation horaire |

| 7 | RTR01 (relais DHCP) | DC01 | UDP 67 | DHCP relayé |

| 8 | Zones utilisateurs | FS01 | TCP 445 | Partages de fichiers |

| 9 | Zones utilisateurs | Internet | TCP 80, 443 | Navigation, mises à jour |

| 10 | DC01, DC02 | Internet | TCP/UDP 53, TCP 80, 443 | Redirecteurs DNS, mises à jour |

| 11 | ANSIBLE01 | Serveurs et postes Linux | TCP 22 | Administration Ansible (SSH) |

| 12 | ANSIBLE01 | Serveurs et postes Windows | TCP 5985, 5986 | Administration Ansible (WinRM) |

| 13 | Zone Administration | Zone Serveurs | TCP 22, 3389, 5985, 5986 | Administration (SSH, RDP, WinRM) |

| 14 | Zone Administration | Internet | TCP 80, 443 | Mises à jour, téléchargements |

| 15 | BK01 | FS01, DC01 | TCP 22, 445 | Récupération des sauvegardes (précisé en phase 9) |



\## Flux interdits explicitement



| Source | Destination | Raison |

| --- | --- | --- |

| Zones utilisateurs | Zone Administration | Protéger les accès d'administration |

| Comptabilité, RH, Autres | Entre elles | Aucun besoin métier, limite la propagation d'une attaque |

| Zones utilisateurs | BK01 | Protéger les sauvegardes (ransomware) |

| Internet | Toutes les zones | Aucun service exposé |



\## Remarques



\- Le trafic \*\*à l'intérieur d'une même zone\*\* (ex. DC01 ↔ DC02) ne passe pas par RTR01. Il est filtré par le pare-feu de chaque machine (pare-feu Windows, nftables sous Linux).

\- Les réponses aux connexions autorisées sont acceptées automatiquement (règle « connexions établies »).

