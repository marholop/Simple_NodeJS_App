# FROM jenkins/jenkins:lts

# USER root

# # install docker cli
# RUN apt-get -y update; apt-get install -y sudo; apt-get install -y git wget
# RUN echo "Jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers
# RUN wget http://get.docker.com/builds/Linux/x86_64/docker-latest.tgz
# RUN tar -xvzf docker-latest.tgz
# RUN mv docker/* /usr/bin/

# # Use an official alpine nodeJS image as the base image
# FROM node:alpine

# # Set working directory in the container
# WORKDIR /app

# # Copy package.json and package-lock.json to the container
# COPY package*.json ./

# # Install only production nodeJS dependencies in Docker Image
# RUN npm install --only=production

# # Copy the rest of the application code into the container
# COPY . .

# # Expose the app on a port
# EXPOSE 3000

# # Command that runs the app
# CMD ["npm", "start"]

FROM jenkins/jenkins

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

ARG GIT_COMMIT=unspecified
LABEL git_commit=$GIT_COMMIT
# Run this command to find git commit:-
#docker inspect quay.io/shazchaudhry/docker-jenkins | jq '.[].ContainerConfig.Labels'

# Configure Jenkins
COPY config/*.xml $JENKINS_HOME/
COPY config/*.groovy /usr/share/jenkins/ref/init.groovy.d/

# Once jenkins is running and configured, run the following command to find the list of plugins installed:
##  curl -s -k "http://admin:admin@localhost:8080/pluginManager/api/json?depth=1" | jq -r '.plugins[].shortName' | tee plugins.txt
RUN /usr/local/bin/install-plugins.sh \
  ace-editor \
  ant \
  antisamy-markup-formatter \
  authentication-tokens \
	blueocean \
  blueocean-autofavorite \
  blueocean-commons \
  blueocean-config \
  blueocean-dashboard \
  blueocean-display-url \
  blueocean-events \
  blueocean-github-pipeline \
  blueocean-git-pipeline \
  blueocean-i18n \
  blueocean-jwt \
  blueocean-personalization \
  blueocean-pipeline-api-impl \
  blueocean-pipeline-editor \
  blueocean-pipeline-scm-api \
  blueocean-rest \
  blueocean-rest-impl \
  blueocean-web \
  bouncycastle-api \
  branch-api \
  build-timeout \
  cloudbees-folder \
  credentials \
  credentials-binding \
  display-url-api \
  docker-commons \
  docker-workflow \
  durable-task \
  email-ext \
  external-monitor-job \
  favorite \
  git \
  git-client \
  github \
  github-api \
  github-branch-source \
  gitlab-plugin \
  git-server \
  global-build-stats \
  gradle \
  handlebars \
  icon-shim \
  jackson2-api \
  jquery-detached \
  junit \
  keycloak \
  ldap \
  mailer \
  mapdb-api \
  matrix-auth \
  matrix-project \
  metrics \
  momentjs \
  pam-auth \
  pipeline-build-step \
  pipeline-github-lib \
  pipeline-graph-analysis \
  pipeline-input-step \
  pipeline-milestone-step \
  pipeline-model-api \
  pipeline-model-declarative-agent \
  pipeline-model-definition \
  pipeline-model-extensions \
  pipeline-rest-api \
  pipeline-stage-step \
  pipeline-stage-tags-metadata \
  pipeline-stage-view \
  plain-credentials \
  pubsub-light \
  purge-job-history \
  resource-disposer \
  role-strategy \
  scm-api \
  script-security \
  sse-gateway \
  ssh-credentials \
  ssh-slaves \
  structs \
  subversion \
  timestamper \
  token-macro \
  variant \
  windows-slaves \
  workflow-aggregator \
  workflow-api \
  workflow-basic-steps \
  workflow-cps \
  workflow-cps-global-lib \
  workflow-durable-task-step \
  workflow-job \
  workflow-multibranch \
  workflow-scm-step \
  workflow-step-api \
  workflow-support \
  ws-cleanup

USER root

# Install Docker from official repo
RUN apt-get update -qq && \
    apt-get install -qqy apt-transport-https ca-certificates curl gnupg2 software-properties-common && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    apt-key fingerprint 0EBFCD88 && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" && \
    apt-get update -qq && \
    apt-get install -qqy docker-ce && \
    usermod -aG docker jenkins && \
    chown -R jenkins:jenkins $JENKINS_HOME/

USER jenkins

VOLUME [$JENKINS_HOME, "/var/run/docker.sock"]