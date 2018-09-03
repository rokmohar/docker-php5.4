cat << EOF > /etc/apache2/sites-available/000-default.conf
# This is the configuration for your project
Listen *:8080

<VirtualHost *:8080>
    ServerName beontra.dev

    DocumentRoot /home/sfproject/web
    DirectoryIndex index.php

    <Directory /home/sfproject/web>
        AllowOverride All
        Require all granted
    </Directory>

    Alias /sf /home/sfproject/lib/vendor/symfony/data/web/sf
    <Directory /home/sfproject/lib/vendor/symfony/data/web/sf>
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF
