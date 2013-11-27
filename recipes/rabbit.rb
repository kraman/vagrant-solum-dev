#
# Cookbook Name:: solum
# Recipe:: rabbit
#
# Copyright 2012, Rackspace US, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#



include_recipe 'rabbitmq::default'
include_recipe 'rabbitmq::plugin_management'
include_recipe 'rabbitmq::mgmt_console'
include_recipe 'rabbitmq::user_management'

# Set up Rabbit Users
rabbitmq_user 'add rabbit admin user' do
  user      node['solum']['rabbit']['admin_user']
  password  node['solum']['rabbit']['admin_pass']
  action    [:add]
end

rabbitmq_user 'set rabbit admin user to admin' do
  user      node['solum']['rabbit']['admin_user']
  tag       'administrator'
  action    [:set_tags]
end

rabbitmq_user 'add solum rabbit user' do
  user      node['solum']['rabbit']['user']
  password  node['solum']['rabbit']['pass']
  action    [:add]
end

# Set up Rabbit Vhosts
node['solum']['rabbit']['vhosts'].each do |vhost|
  rabbitmq_vhost vhost do
    action  [:add]
  end
  rabbitmq_user "set perms for rabbit user for #{vhost}" do
    user        node['solum']['rabbit']['user']
    vhost       vhost
    permissions '.* .* .*'
    action [:set_permissions]
  end
end
