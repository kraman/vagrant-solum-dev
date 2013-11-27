#
# Cookbook Name:: solum
# Recipe:: user
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

include_recipe 'sudo'

# User Setup

user node['solum']['user'] do
  username  node['solum']['user']
  comment   "Solum User"
  shell     "/bin/bash"
  home      "/home/solum"
  system    true
end
