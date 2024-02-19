FROM tomcat:8.0
MAINTAINER pandian
COPY **/*.war /usr/local/tomcat/webapps/
