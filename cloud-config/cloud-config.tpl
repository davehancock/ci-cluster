#cloud-config

# Jenkins Node
############################################

coreos:
  units:
    - name: jenkins.service
      command: start
      content: |
        [Unit]
        Description=Jenkins master node
        After=docker.service
        Requires=docker.service

        [Service]
        Restart=always
        RestartSec=15
        ExecStartPre=-/bin/bash -c "sudo mkdir -p /var/jenkins_home && sudo chown 1000:1000 /var/jenkins_home"
        ExecStart=/usr/bin/docker run \
            --name jenkins-master \
            --privileged \
            --user root \
            -p 80:8080 \
            -v /var/jenkins_home:/var/jenkins_home \
            -v /var/run/docker.sock:/var/run/docker.sock \
            -m 1g \
            jenkinsci/blueocean:1.1.5
        ExecStopPost=/usr/bin/docker stop jenkins-master
        ExecStopPost=/usr/bin/docker rm jenkins-master


    - name: webhook.service
      command: start
      content: |
        [Unit]
        Description=Retrieves a Jenkins Key

        [Service]
        Restart=on-failure
        RestartSec=15
        ExecStartPre=/bin/bash -c "sudo ls /var/jenkins_home/secrets/initialAdminPassword"
        ExecStart=/bin/bash -c "curl -X POST -H 'Content-type: application/json' --data '{\"text\": \"Your Initial CI Cluster password is: *'$(sudo cat /var/jenkins_home/secrets/initialAdminPassword)'*\", \"username\": \"ci-cluster-security\", \"icon_emoji\": \":desktop_computer:\"}' https://hooks.slack.com/services/${ci_webhook_token}"
