require 'spec_helper'

describe port(7946) do
  it { should be_listening.with('tcp') }
  it { should be_listening.with('udp') }
end

describe port(7373) do
  it { should be_listening }
end

describe package('unzip') do
  it { should be_installed }
end

describe file('/usr/local/serf/bin/serf') do
  it { should be_file }
  it { should be_executable }
end

describe file('/usr/local/serf/bin/serf_ctl') do
  it { should be_file }
  it { should be_executable }
end

describe file('/usr/local/serf/conf/serf_conf.json') do
  it { should be_file }
end

describe file('/etc/monit/conf.d/serf_monit') do
  it { should be_file }
end

describe process('serf agent') do
  it { should be_running }
end
