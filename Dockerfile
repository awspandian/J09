FROM tomcat:9
MAINTAINER pandian
COPY **/*.war /usr/local/tomcat/webapps/
