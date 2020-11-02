#
# Cookbook Name:: virtualbox
# Attributes:: default
#
# Copyright 2011, Joshua Timberman
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


default['virtualbox']['url'] = ''
default['virtualbox']['gpg_key'] = 'http://download.virtualbox.org/virtualbox/debian/oracle_vbox_2016.asc'
default['virtualbox']['version'] = ''

case node['platform_family']
when 'mac_os_x'
  default['virtualbox']['url'] = 'https://download.virtualbox.org/virtualbox/6.1.16/VirtualBox-6.1.16-140961-OSX.dmg'
when 'windows'
  default['virtualbox']['url'] = 'https://download.virtualbox.org/virtualbox/6.1.16/VirtualBox-6.1.16-140961-Win.exe'
  default['virtualbox']['version'] = Vbox::Helpers.vbox_version(node['virtualbox']['url'])
when 'debian'
  default['virtualbox']['version'] = '6.1.16'
  default['virtualbox']['url'] = 'http://download.virtualbox.org/virtualbox/debian'
when 'rhel', 'fedora'
  default['virtualbox']['version'] = '6.1.16'
  default['virtualbox']['gpg_key'] = 'http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc'
  default['virtualbox']['url'] = "http://download.virtualbox.org/virtualbox/rpm/#{node['platform_family']}/$releasever/$basearch"
end
