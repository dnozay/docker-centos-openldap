FROM centos:latest
MAINTAINER Damien Nozay <damien.nozay@gmail.com>

# install software
RUN \
  yum -y update && \
  yum -y install openldap-servers && \
  yum -y install openldap-clients && \
  yum -y clean all

# clear default config
VOLUME /etc/openldap /var/lib/ldap
EXPOSE 389

# configure server
COPY DB_CONFIG  /var/lib/ldap/DB_CONFIG
RUN chown -R ldap:ldap /var/lib/ldap /etc/openldap/slapd.d

# start service
WORKDIR /etc/openldap/slapd.d
# check that volume mounting worked
RUN test -f /etc/openldap/CHECK
RUN slaptest -v -d -1 -F /etc/openldap/slapd.d
ENTRYPOINT slapd -d config -F /etc/openldap/slapd.d -h 'ldap:/// ldapi:///' -u ldap -g ldap
