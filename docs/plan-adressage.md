# Plan d'adressage

| Zone | Réseau | Usage |
| --- | --- | --- |
| Serveurs | 10.50.10.0/24 | DC01, DC02, FS01, BK01 |
| Comptabilité | 10.50.20.0/24 | Postes comptabilité |
| RH | 10.50.30.0/24 | Postes RH |
| Autres utilisateurs | 10.50.40.0/24 | Direction, commercial, opérations |
| Administration | 10.50.99.0/24 | ANSIBLE01, postes informatique |

| Serveur | IP |
| --- | --- |
| DC01 | 10.50.10.11 |
| DC02 | 10.50.10.12 |
| FS01 | 10.50.10.20 |
| BK01 | 10.50.10.30 |
| ANSIBLE01 | 10.50.99.10 |
| Routeur | .1 de chaque zone |