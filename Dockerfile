FROM registry.redhat.io/openshift4/ose-jenkins

USER 0

# System Environment Variables
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Setup Java 
RUN ln -s /etc/alternatives/java /usr/bin/java
RUN ls -la /usr/bin/java

# Jenkins Environment Variables
ENV JENKINS_VERSION=2.277.3 \
    JENKINS_PLUGINS=/var/lib/jenkins/plugins

# Setup Work Directory
ENV WORK_DIR=/home/workdir
RUN mkdir -p ${WORK_DIR}
WORKDIR ${WORK_DIR}

# Install Jenkins Plugin Manager and Plugins
RUN wget https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/2.10.0/jenkins-plugin-manager-2.10.0.jar 
RUN chmod 777 jenkins-plugin-manager-2.10.0.jar
RUN java -jar jenkins-plugin-manager-2.10.0.jar --jenkins-version=${JENKINS_VERSION} --plugins=gitlab-plugin:1.5.20 --plugin-download-directory=${WORK_DIR}

# Cleanup
RUN unlink /usr/bin/java

WORKDIR  /go/src/github.com/openshift/jenkins/go-init

USER 1001

ENTRYPOINT ["/usr/bin/go-init", "-main", "/usr/libexec/s2i/run", "&&"]
# CMD ["cp", "-p", "${WORK_DIR}/*.jpi", "${JENKINS_PLUGINS}"]

