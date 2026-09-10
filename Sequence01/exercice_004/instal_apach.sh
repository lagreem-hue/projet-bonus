#!/bin/bash
set -e

DOMAIN="monsite.local"
DOC_ROOT="/var/www/$DOMAIN"
VHOST_FILE="/etc/apache2/sites-available/$DOMAIN.conf"

echo "Installation d’Apache..."
sudo apt update -y
sudo apt install apache2 -y

echo "Création du répertoire du site : $DOC_ROOT"
sudo mkdir -p "$DOC_ROOT"
sudo chown -R "$USER:$USER" "$DOC_ROOT"

echo "Création de la page index.html"
cat <<EOF | sudo tee "$DOC_ROOT/index.html"
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Bienvenue sur $DOMAIN</title>
</head>
<body>
    <h1>Apache fonctionne correctement !</h1>
    <p>Virtual Host : $DOMAIN</p>
</body>
</html>
EOF

echo "Configuration du Virtual Host..."
cat <<EOF | sudo tee "$VHOST_FILE"
<VirtualHost *:80>
    ServerAdmin webmaster@$DOMAIN
    ServerName $DOMAIN
    ServerAlias www.$DOMAIN
    DocumentRoot $DOC_ROOT
    ErrorLog \${APACHE_LOG_DIR}/$DOMAIN-error.log
    CustomLog \${APACHE_LOG_DIR}/$DOMAIN-access.log combined
</VirtualHost>
EOF

echo "Activation du site $DOMAIN..."
sudo a2ensite "$DOMAIN.conf"
sudo a2dissite 000-default.conf

echo "Test de la configuration Apache..."
sudo apache2ctl configtest

echo "Redémarrage du service Apache..."
sudo systemctl restart apache2

sudo systemctl enable apache2

echo "Installation terminée !"
echo "Votre site est disponible à l’adresse : http://$DOMAIN"

