#cloud-config

# Jenkins Node
############################################

coreos:
  units:
    - name: jenkins.service
      command: start
      content: |
        [Unit]
        Description=Start a Jenkins master node
        After=docker.service
        Requires=docker.service

        [Service]
        Restart=always
        RestartSec=15
        ExecStart=/usr/bin/docker run \
            --name jenkins-master \
            -p 80:8080 \
            -m 400m \
            jenkinsci/blueocean:1.1.2
        ExecStopPost=/usr/bin/docker stop jenkins-master
        ExecStopPost=/usr/bin/docker rm jenkins-master
