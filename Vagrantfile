$script = <<~SCRIPT
  curl -o /etc/yum.repos.d/heimdall.repo https://dl.packager.io/srv/mitre/heimdall/master/installer/el/7.repo
  yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm

  yum install -y heimdall

  /usr/pgsql-11/bin/postgresql-11-setup initdb
  echo "local   all             all                                trust" > /var/lib/pgsql/11/data/pg_hba.conf
  systemctl enable postgresql-11
  systemctl start postgresql-11
  sudo -u postgres createuser --superuser heimdall
  heimdall config:set DATABASE_URL=postgresql:///heimdall_production
  heimdall run rake db:create db:schema:load || true
  heimdall run rake db:migrate
  heimdall scale web=1
SCRIPT

Vagrant.configure('2') do |config|
  config.vm.box = 'centos/7'

  config.vm.provision 'shell', inline: $script

  config.vm.network 'forwarded_port', guest: 6000, host: 3000
end
