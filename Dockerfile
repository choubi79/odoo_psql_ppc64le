FROM ubuntu
MAINTAINER s.chabrolles@fr.ibm.com

RUN adduser --system --home=/opt/odoo --group odoo

RUN apt-get update

RUN apt-get install -y python-dateutil python-decorator python-docutils python-feedparser \
python-gdata python-gevent python-imaging python-jinja2 python-ldap python-libxslt1 python-lxml \
python-mako python-mock python-openid python-passlib python-psutil python-psycopg2 python-pybabel \
python-pychart python-pydot python-pyparsing python-pypdf python-reportlab python-requests \
python-simplejson python-tz python-unittest2 python-vatnumber python-vobject python-werkzeug \
python-xlwt python-yaml wkhtmltopdf postgresql git

#RUN /etc/init.d/postgresql start

USER postgres
ADD ./postgres.modif /tmp/postgres.modif
#RUN /etc/init.d/postgresql start &&\
# createuser --createdb --username postgres --no-createrole --no-superuser odoo &&\   
# createdb -O odoopasswd odoo
# psql --command "ALTER USER odoo WITH PASSWORD 'odoopasswd';" &&\
# psql --command "update pg_database set datallowconn = TRUE where datname = 'template0';" &&\
# psql --command "\c template0" &&\
# psql --command "update pg_database set datistemplate = FALSE where datname = 'template1';" &&\
# psql --command "drop database template1;" &&\psql --command "drop database template1;" &&\
# psql --command "create database template1 with template = template0 encoding = 'UTF8';" &&\
# psql --command "update pg_database set datistemplate = TRUE where datname = 'template1';" &&\
# psql --command "\c template1" &&\
# psql --command "update pg_database set datallowconn = FALSE where datname = 'template0';" &&\
RUN /etc/init.d/postgresql start &&\
 createuser --createdb --username postgres --no-createrole --no-superuser odoo &&\   
 /bin/bash /tmp/postgres.modif

USER odoo 
RUN git clone https://www.github.com/odoo/odoo --depth 1 --branch 8.0 --single-branch /opt/odoo 

#USER root
#/bin/bash su - odoo -s git clone https://www.github.com/odoo/odoo --depth 1 --branch 8.0 --single-branch .

USER root

#cp /opt/odoo/debian/openerp-server.conf /etc/odoo-server.conf
#chown odoo: /etc/odoo-server.conf
#chmod 640 /etc/odoo-server.conf
ADD ./odoo-server.conf /etc/odoo-server.conf
ADD ./start_all.sh /start_all.sh
RUN chown odoo: /etc/odoo-server.conf &&\
 chmod 640 /etc/odoo-server.conf &&\
 chmod a+x /start_all.sh

# Clean
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/

# Expose the Odoo port
EXPOSE 8069

# Set the default command to run when starting the container
CMD ["/bin/bash","/start_all.sh"]
