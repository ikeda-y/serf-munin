include_attribute 'monit'

default[:serf][:install_dir] = '/usr/local/serf'
default[:serf][:download_file] = '0.4.0_linux_amd64.zip'
default[:serf][:url] = "https://dl.bintray.com/mitchellh/serf/#{default[:serf][:download_file]}"

default[:serf][:master][:role] = 'master'
default[:serf][:master][:bind] = '0.0.0.0:7946'
default[:serf][:master][:event_handlers] = nil
default[:serf][:master][:advertise] = "#{default[:serf][:master][:bind]}"
default[:serf][:master][:rpc_addr] = '127.0.0.1:7373'

default[:serf][:node][:role] = 'node'
bind_addr = `ip address show dev eth0 | egrep "inet.*eth0" | awk '{print $2}' | awk -F / '{print $1}'`.chomp
default[:serf][:node][:bind] = "#{bind_addr}:7946"
default[:serf][:node][:advertise] = "#{default[:serf][:node][:bind]}"
default[:serf][:node][:rpc_addr] = '127.0.0.1:7373'
default[:serf][:node][:start_join] = [ "#{default[:serf][:node][:bind]}" ]
default[:serf][:node][:event_handlers] = nil

default[:serf][:encrypt_key] = nil
default[:serf][:log_level] = 'warn'
default[:serf][:profile] = 'lan'
default[:serf][:leave_on_terminate] = false
default[:serf][:skip_leave_on_interrupt] = false

default[:monit][:source] = 'installer'
