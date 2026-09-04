# compagnon : le /etc/nixos du livre, consignation après consignation

Ce dépôt est le `/etc/nixos` que vous construisez en suivant *NixOS : Le
système déclaratif*, depuis le chapitre « Structurer sa configuration », où il
entre sous git, jusqu'à la dernière page. Chaque commit est une consignation
imprimée, avec le message du livre au caractère près : ni plus, ni moins.

Il sert à deux choses :

- **comparer** votre dépôt au nôtre, à n'importe quel point du livre ;
- **rattraper** un fichier qui se serait égaré en chemin.

Il ne se déploie pas tel quel : ses clés, ses coffres et ses constats matériels
sont ceux de nos machines, pas des vôtres (voir « Ce qui diffère chez vous »).

## Les points de contrôle

Un tag par chapitre marque sa dernière consignation : `13-structurer`,
`14-services`, et ainsi de suite jusqu'à `32-contribuer`, plus `fin-recit`.
« Les canaux et leurs limites » ne consigne rien : pas de tag `18-`.

```console
$ git log --oneline 20-packager..21-overlays    # les consignations d'un chapitre
$ git diff 20-packager 21-overlays               # tout ce qu'il a changé
$ git show 22-secrets:modules/utilisateurs.nix   # un fichier, tel qu'il était
```

Le `git diff` entre deux tags redit, fichier par fichier, les lignes que le
chapitre marque `[+]` et `[-]` en marge.

## Les branches

- `main` : le récit, de « Structurer sa configuration » à « Contribuer à
  nixpkgs » ;
- `executeur` : l'annexe F, « L'exécuteur de la forge » (tag `F-executeur`) ;
- `machine-reelle` : l'annexe G, « La station sur machine réelle » (tag
  `G-station`).

Les deux annexes partent de `fin-recit` et s'ignorent l'une l'autre :
la station réelle se passe très bien de l'exécuteur.

## Avant git

Les chapitres 4 à 12 (le laboratoire, puis la station jusqu'à « Casser et
réparer ») précèdent le premier commit. Leurs états vivent en dossiers dans le
dépôt [extraits](https://github.com/nixos-le-systeme-declaratif/extraits), avec
les feuilles de commandes de chaque chapitre.

## Ce qui diffère chez vous

Votre dépôt ne sera jamais identique au nôtre, et c'est normal. Attendez-vous à
ces écarts, et à eux seuls :

- **les empreintes de commit et les dates** : ce sont celles de votre histoire ;
- **les identités** : les clés age de `.sops.yaml`, les clés SSH
  (`authorizedKeys`, `knownHosts`), la clé de signature `atelier-1:…`
  d'`acces-distant.nix`. Ce dépôt porte celles que le livre imprime ; là où la
  page en abrège une (`AAAAIB7fq…`), il en garde le début imprimé. Chaque
  machine et chaque personne tire les siennes au hasard : les vôtres seront
  différentes ;
- **les coffres** `secrets/*.yaml` : chiffrés pour les clés du livre, donc
  illisibles pour vous, et ils ne contiennent que des marqueurs à la place des
  valeurs. Ils montrent leur forme (les noms des secrets, les destinataires) ;
  les vôtres se chiffrent pour vos clés ;
- **les constats matériels** (`hardware-configuration.nix`) : ceux de nos
  machines ; sur la branche `machine-reelle`, ceux d'une vraie machine, qui
  n'est pas la vôtre ;
- **`certificats/`** : l'autorité de notre maison ; la vôtre sera la vôtre ;
- **le verrou** `flake.lock` : il fige nixpkgs au commit que le livre a
  épinglé, `b3fe958`. L'entrée suit la branche `nixos-26.05`, comme dans le
  livre ; `flake.nix` porte en commentaire l'épingle exacte, pour qui veut
  retrouver nos versions à l'octet près (l'encadré « épingler exactement l'eau
  de son canal » du chapitre « Les flakes : migration ») ;
- **l'entrée `site`** du flake pointe sur `https://forge/camille/carnet.git`,
  votre forge privée (chapitre « La forge privée ») : elle ne se résout que chez
  vous. Le carnet d'origine est
  [ici](https://github.com/nixos-le-systeme-declaratif/carnet) ;
- **les adresses** `192.168.122.x` : celles de notre hyperviseur ; le livre vous
  apprend à relever les vôtres.

Un geste du livre est conditionnel et n'entre pas dans cette histoire :
« l'annuaire se corrige » (chapitre « Naissance du serveur »), si l'adresse de
votre vitrine diffère de la nôtre.

Deux lignes, enfin, ne sont pas dans le livre : l'épingle commentée de
`flake.nix`, et le rappel, au-dessus de `trusted-public-keys`, que la clé de
signature est celle de *votre* atelier. Ce `README.md` et la `LICENSE` sont les
seuls autres intrus.

## Une coquille ?

Ouvrez une *issue* sur ce dépôt : votre signalement profitera aussi aux
lecteurs suivants.

## Licence

[CC0 1.0](LICENSE) : copiez, adaptez, sans condition.

---

**Ce projet est indépendant.** Il n'est ni affilié à, ni approuvé par la NixOS
Foundation ou le projet communautaire NixOS ; « NixOS » y est employé
uniquement pour désigner le système d'exploitation dont le livre traite. Site
officiel du projet communautaire : [nixos.org](https://nixos.org).

*This is an independent companion repository for a French-language book about
NixOS. It is not affiliated with or endorsed by the NixOS Foundation.*
