FROM sdldevelopers/jenkins:base

USER root

RUN apk --no-cache update && \
    apk --no-cache add sudo docker openrc && \
    apk --no-cache add python py-pip python2-dev && \
    apk --no-cache add gcc linux-headers musl-dev && \
    apk --purge del build-deps && \
    rm -rf /var/cache/apk/* 

RUN rc-update add docker boot
RUN addgroup jenkins docker
RUN echo "jenkins ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER jenkins

ENV HOME /var/jenkins_home

COPY --chown=jenkins:jenkins myPrivateKey.pem $HOME/.ssh/myPrivateKey.pem
COPY --chown=jenkins:jenkins myPublicKey.pub  $HOME/.ssh/myPublicKey.pub
COPY --chown=jenkins:jenkins ssh_config  $HOME/.ssh/config

ENV JAVA_OPTS "-Dhudson.security.HudsonPrivateSecurityRealm.ID_REGEX=[a-z0-9_.@-]+"

USER root

COPY start_jenkins.sh /usr/sbin/start_jenkins.sh
RUN chmod a+rx /usr/sbin/start_jenkins.sh

USER jenkins

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

ENTRYPOINT ["/usr/sbin/start_jenkins.sh"]
