Site café-vie-privée.fr
=======================

Environnement
-------------

Le site [café-vie-privée.fr](https://café-vie-privée.fr) est généré en utilisant [Middleman](https://middlemanapp.com/).
 
Pour l'installer, vous devez disposer d'un environnement Ruby fonctionnel. Si vous n'en avez pas, vous pouvez installer 
*[rbenv](https://github.com/sstephenson/rbenv)*. Installez ensuite Middleman en lançant :

    gem install middleman
    
Si vous utilisez *rvm*, *middleman* devrait être dans votre *path*. 

Lancement
---------

Vous pouvez lancer un serveur en local en lançant la commande `middleman server`. Si ce n'est déjà fait, il est 
nécessaire de créer un fichier `deploy.yaml` de la forme suivante :
 
    method: [...]
    host: [...]
    path: [...]
    port: [...]
    build_before: [...]

Un fichier d'exemple est fourni avec ce dépôt : `deploy.yaml.example`. Pour en savoir plus, [voir la documentation de `middleman-deploy`](https://github.com/middleman-contrib/middleman-deploy).

Après avoir lancé le serveur, vous devriez accéder à votre version locale du site en accédant à `http://localhost:4567` 
comme indiqué dans la console :
 
    == The Middleman is loading
    == The Middleman is standing watch at http://0.0.0.0:4567
    == Inspect your site configuration at http://0.0.0.0:4567/__middleman/
