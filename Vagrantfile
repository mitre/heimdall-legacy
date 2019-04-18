$script = <<-SCRIPT
cat >/etc/yum.repos.d/mongodb-org-4.0.repo <<EOF
[mongodb-org-4.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/\\$releasever/mongodb-org/4.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.0.asc
EOF

curl -o /etc/yum.repos.d/heimdall.repo https://dl.packager.io/srv/mitre/heimdall/master/installer/el/7.repo

yum install -y heimdall

systemctl start mongod
systemctl enable mongod

heimdall scale web=1
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"

  config.vm.provision "shell", inline: $script

  config.vm.network "forwarded_port", guest: 6000, host: 3000
end
