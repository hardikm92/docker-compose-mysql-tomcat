#
# app
#

FROM tomcat:7-jre8

ENV FAKE_WAR_NAME=iiq.war
ENV DEPLOY_WAR_NAME=identityiq.war


RUN rm -rf /usr/local/tomcat/webapps/*
COPY ./$FAKE_WAR_NAME /tmp/
RUN mv /tmp/$FAKE_WAR_NAME /usr/local/tomcat/webapps/$DEPLOY_WAR_NAME

COPY ./start-app.sh /root/start-app.sh
EXPOSE 8080
CMD ["/root/start-app.sh"]
