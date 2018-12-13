#!/bin/bash
git config --global user.email "jenkins@jenkins"
git config --global user.name  "Jenkins"

# Here I can execute all pre-start stuff...

/sbin/tini -- /usr/local/bin/jenkins.sh
