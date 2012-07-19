
package "xinetd" do
  action :install
end

service "xinetd" do
  supports :status => true, :restart => true
  action :nothing
end

template "mysqlchck" do
  path "/etc/xinetd.d/mysqlchk"
  source "mysqlchk.erb"
  owner "root"
  group "root"
  mode "644"
  notifies :enable, "service[xinetd]"
  notifies :start,  "service[xinetd]"  
end

template "xinetd.conf" do
  path "/etc/xinetd.conf"
  source "xinetd.conf.erb"
  owner "root"
  group "root"
  mode "644"
  notifies :enable, "service[xinetd]"
  notifies :start,  "service[xinetd]"  
end

template "services" do
  path "/etc/services"
  source "services.erb"
  owner "root"
  group "root"
  mode "644"
  notifies :enable, "service[xinetd]"
  notifies :start,  "service[xinetd]"
end




