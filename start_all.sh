#/bin/bash

/etc/init.d/postgresql start
su - odoo -s /opt/odoo/openerp-server
