#
# Cookbook Name:: haproxy
# Recipe:: app_lb
#
# Copyright 2009, Opscode, Inc.
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


# Let the default recip install haproxy and 
# write /etc/default/haproxy, /etc/haproxy/haproxy.cfg
# and set up the service.
include_recipe "haproxy::default"

# The `config_data_items` attribute should be defined, and contain
# a list of data bag items that define each instance of haproxy;
# this contains information such as hostname/ipaddress/port of the
pool_members = []
node['haproxy']['config_data_items'].each do |proxy_data_bag_name|
  search(:haproxy, "id:#{proxy_data_bag_name}") do |proxy_data|
    pool_members << proxy_data
    Chef::Log.info("Setting up HAProxy Pool Member #{proxy_data[:hostname]}")
  end
end

# Overwrite the haproxy config with data from our app pool
template "/etc/haproxy/haproxy.cfg" do
  source "haproxy-app_lb.cfg.erb"
  owner "root"
  group "root"
  mode 0644
  variables :pool_members => pool_members.uniq
  notifies :restart, "service[haproxy]"
end
