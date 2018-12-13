## Jenkins Docker
You can find more information in the [Official Jenkins Docker's GitHub](https://github.com/jenkinsci/docker)

## How to start the Docker ?
docker run --rm -p 8080:8080 \
           --log-opt max-size=100m --log-opt max-file=3 \
           -v /var/run/docker.sock:/var/run/docker.sock \
           --name jenkins jenkins/jenkins:lts-alpine > /dev/null 2>&1

## Setting admin password
You may want to create the admin account and set a password during the first boot. For that purpose you can copy the file 'security.groovy' that you can find in this folder to /usr/share/jenkins/ref/init.groovy.d/
In the Docker file you should add the line:
```
COPY security.groovy /usr/share/jenkins/ref/init.groovy.d/security.groovy
```
Tip: Once everything is configured as you like you will not want to use this file anymore.

## Plugins
As you can see in the Docker file I am uploading a file with a list of plugins. You can start the Docker, install all plugins you need and update that file.
If you want to get the list of plugins installed you can do it with a something like this:
```bash
#!/bin/bash
USER=admin
PASSWORD=MySuperStrongPassword
HOST=localhost
PORT=8080
JENKINS_HOST=$USER:$PASSWORD@$HOST:$PORT

curl -sSL "http://$JENKINS_HOST/pluginManager/api/xml?depth=1&xpath=/*/*/shortName|/*/*/version&wrapper=plugins" | sed -e 's#</version>#\n#g' -e 's#<shortName>##g' -e 's#</shortName><version>#:#g' | sed -e 's/^<.*>//g' > plugins.txt
``` 
Note the plugins.txt file in this folder has been altered. You will have to create your own with the script above.
You can automate the update of the plugins file and upload it to your git repository or so. In case you have to delete the docker and start it again the plugins' list will always be updated. 

## Understanding the Dockerfile
* At the beginning of the file I download some packages I need and I clean all cache after installing everything because I want the docker to be the smallest possible.
* I configure the docker service to start at boot and I add the jenkins user to the docker's group.
* Since everything will be automated I add the Jenkins user to the sudoers and I will allow it to use sudo without entering a password. 
* I'm copying the SSH keys and config file because I want to be able to connect to git repositories and another servers passwordless.
* In the latest versions of Jenkins you cannot create users using the email address because characters like . and @ are not allowed anymore by default. You can override that behaviour with the line:
```
ENV JAVA_OPTS "-Dhudson.security.HudsonPrivateSecurityRealm.ID_REGEX=[a-z0-9_.@-]+"
```
* I copy my custom plugins to the Docker and install them all.
* To finish, instead of leaving Jenkins to start the service for me I override it with a custom script so that I can update repositories and configure many things before the service starts.

