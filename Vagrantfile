$script = <<~SCRIPT
  curl -o /etc/yum.repos.d/heimdall.repo https://dl.packager.io/srv/mitre/heimdall_activerecord/master/installer/el/7.repo

  yum install -y heimdall-activerecord

  postgresql-setup initdb
  echo "local   all             postgres                                trust" > /var/lib/pgsql/data/pg_hba.conf
  systemctl enable postgresql
  systemctl start postgresql

  heimdall-activerecord run rake db:create db:schema:load || true
  heimdall-activerecord run rake db:migrate
  heimdall-activerecord scale web=1
SCRIPT

Vagrant.configure('2') do |config|
  config.vm.box = 'centos/7'

  config.vm.provision 'shell', inline: $script

  config.vm.network 'forwarded_port', guest: 6000, host: 3000
end
