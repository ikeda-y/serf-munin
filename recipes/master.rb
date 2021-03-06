include_recipe 'munin::master'
include_recipe 'monit'

home = node[:serf][:install_dir]
bin_path = home + '/bin'
conf_path = home + '/conf'

user = 'root'
group = 'root'

# Download serf
remote_file '/tmp/' + node[:serf][:download_file] do
  source node[:serf][:url]
  mode '0644'
  action :create_if_missing
end

# Install unzip
package 'unzip' do
  action :install
end

# Create directory
directory bin_path do
  action :create
  owner "#{user}"
  group "#{group}"
  mode '0755'
  recursive true
end

directory conf_path do
  action :create
  owner "#{user}"
  group "#{group}"
  mode '0755'
end

# Setup serf
execute 'Setup serf' do
  command <<-EOH
    cd /tmp
    unzip #{node[:serf][:download_file]}
    chmod 700 /tmp/serf
    sudo mv /tmp/serf #{bin_path}
  EOH
end

# Setup serf-munin script
cookbook_file bin_path + '/serf_munin' do
  source 'serf_munin.sh'
  owner "#{user}"
  group "#{group}"
  mode '0700'
end

# Create serf config
template conf_path + '/serf_conf.json' do
  source 'serf_conf_master.json.erb'
  owner "#{user}"
  group "#{group}"
  mode '0600'
  notifies :restart, 'service[monit]'
end

# Setup munin config cleaner
template bin_path + '/munin_conf_cleaner' do
  source 'munin_conf_cleaner.erb'
  owner "#{user}"
  group "#{group}"
  mode '0700'
end

cron 'munin_conf_cleaner' do
  minute  node[:serf][:cleaner][:cron][:minute]
  hour    node[:serf][:cleaner][:cron][:hour]
  day     node[:serf][:cleaner][:cron][:day]
  month   node[:serf][:cleaner][:cron][:month]
  weekday node[:serf][:cleaner][:cron][:weekday]
  user    "#{user}"
  command bin_path + "/munin_conf_cleaner"
end

# Create monit script for serf
template bin_path + '/serf_ctl' do
  source 'serf_ctl.erb'
  owner "#{user}"
  group "#{group}"
  mode '0700'
  notifies :restart, 'service[monit]'
end

# Create monit config for serf
template '/etc/monit/conf.d/serf_monit' do
  source 'serf_monit.erb'
  owner "#{user}"
  group "#{group}"
  mode '0600'
  notifies :restart, 'service[monit]'
end

# Restart serf
execute 'Restart serf' do
  command <<-EOH
    sudo #{bin_path}/serf_ctl stop
    sudo #{bin_path}/serf_ctl start &
  EOH
end
