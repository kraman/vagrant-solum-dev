name             'solum'
maintainer       "Rackspace US, Inc"
license          "Apache 2.0"
description      'Installs/Configures solum dev environment'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

%w{ ubuntu }.each do |os|
  supports os
end

%w{ sudo database mysql rabbitmq python }.each do |dep|
  depends dep
end

recipe "solum::default",
  "Sets up solum dev environmentals."


