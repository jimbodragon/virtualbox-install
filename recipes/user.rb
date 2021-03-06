#
# Cookbook Name:: virtualbox
# Recipe:: user
#
# Copyright 2012, Ringo De Smet
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

# For the user to be created successfully, a data bag item with the MD5 hashed password
# needs to be added.
chef_gem "unix-crypt" do
  action :upgrade
  compile_time true
end

ruby_block 'Include unix_crypt to LinuxUser resource' do
  block do
    require 'unix_crypt'
    Chef::Resource::User.send(:include, UnixCrypt)
  end
  action :run
  compile_time true
end

execute "stop zentyal webadmin" do
  action :nothing
  command "/usr/bin/zs webadmin stop"
end

execute "start zentyal webadmin" do
  action :nothing
  command "/usr/bin/zs webadmin start"
end

user 'virtualbox-user' do
  username node[cookbook_name]['user']
  gid node[cookbook_name]['group']
  password UnixCrypt::SHA512.build(data_bag_item('passwords','virtualbox-user')['password'])
  home node[cookbook_name]['user'] == default_apache_user ? default_apache_user_home : "/home/#{node[cookbook_name]['user']}"
  shell "/bin/bash"
  system true
  manage_home true
  notifies :stop, 'service[apache2]', :before if node[cookbook_name]['user'] == default_apache_user
  if node['packages'].include?("zentyal-core")
    notifies :run, 'execute[stop zentyal webadmin]', :before
    notifies :run, 'execute[start zentyal webadmin]', :delayed
  end
end
