#
# Cookbook Name:: solum
# Recipe:: database
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

include_recipe 'database'
include_recipe 'mysql::ruby'
include_recipe 'mysql::client'
include_recipe 'mysql::server'

# Database Setup

mysql_connection_info = {
  :host     => 'localhost',
  :username => 'root',
  :password => node['mysql']['server_root_password']
}

database 'create solum database' do
  connection mysql_connection_info
  database_name   node['solum']['db']['name']
  provider        Chef::Provider::Database::Mysql
  action          [:create]
end

database_user 'grant privs to solum user@%' do
  connection    mysql_connection_info
  provider      Chef::Provider::Database::MysqlUser
  username      node['solum']['db']['user']
  password      node['solum']['db']['pass']
  database_name node['solum']['db']['name']
  host          '%'
  privileges    [:select,:update,:insert]
  action        [:grant]
end

database_user 'grant privs to solum user@localhost' do
  connection    mysql_connection_info
  provider      Chef::Provider::Database::MysqlUser
  username      node['solum']['db']['user']
  password      node['solum']['db']['pass']
  database_name node['solum']['db']['name']
  host          'localhost'
  privileges    [:select,:update,:insert]
  action        [:grant]
end


