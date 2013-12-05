#
# Cookbook Name:: schl_haproxy
# Recipe:: default
#
# Copyright (C) 2013 Ben Gilbert
# 
# All rights reserved - Do Not Redistribute
#
package "haproxy" do
  action :install
end

template "/etc/default/haproxy" do
  source "haproxy-default.erb"
end

service "haproxy" do
  action [:enable, :start]
end

webapp1 = search(:node,"role:web_app1").map { |w| [ w["ipaddress"], w["fqdn"] ] }
webapp2 = search(:node,"role:web_app2").map { |w| [ w["ipaddress"], w["fqdn"] ] }

template "/etc/haproxy/haproxy.cfg" do
  source "haproxy.cfg.erb"
  variables(
        :webapp1 => webapp1,
        :webapp2 => webapp2
)
  notifies :restart, resources(:service => "haproxy")
end
