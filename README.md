# owncloud client
installare sul nodo il client di owncloud:
```
sudo sh -c "echo 'deb http://download.opensuse.org/repositories/isv:/ownCloud:/desktop/Ubuntu_16.04/ /' > /etc/apt/sources.list.d/isv:ownCloud:desktop.list"
wget -nv https://download.opensuse.org/repositories/isv:ownCloud:desktop/Ubuntu_16.04/Release.key -O Release.key
sudo apt-key add - < Release.key
sudo apt-get update
sudo apt-get install owncloud-client
```
# folder
Creare le due folder:

`/var/bigbluebutton/recording/scalelite`
e `/owncloud`

Le due folder devono essere scrivibili dall'utente `bigbluebutton:bigbluebutton`

# script

il file `cowncloud_post_publish.rb` deve essere copiato in 
`/usr/local/bigbluebutton/core/scripts/post_publish`
Il file `owncloud.yml` deve essere copiato in
`/usr/local/bigbluebutton/core/scripts/`

# configurazione
modoficare utente, password e URL del server owncloud nel file `owncloud.yml`



# log
Per debug o in caso di problemi far riferimento al log:
`bbb-rap-worker.log` presente in `/var/log/bigbluebutton/`
