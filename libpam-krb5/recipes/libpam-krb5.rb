#
# Cookbook Name:: libpam-krb5
# Recipe:: libpam-krb5
#
#   Copyright 2012 Mathew Odden
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

# only run if we have attributes setup; can't easily guess these
if node[:kerberos] && node[:kerberos][:domain] && node[:kerberos][:servers] && node[:kerberos][:admin_server] 
	# this is only gonna work on debian/ubuntu
	case node[:platform]
	when "debian","ubuntu"

		# build a directory for pre-config file
		directory "/var/cache/local/preseeding" do
			owner "root"
			group "root"
			mode 0755
			recursive true
		end

		# do preseed values
		execute "preseed-krb5-config" do
			command "debconf-set-selections /var/cache/local/preseeding/krb5-config.preseed.erb"
			action :nothing
		end

		# build preseed file
		template "/var/cache/local/preseeding/krb5-config.preseed.erb" do
			source "krb5-config.preseed.erb"
			owner "root"
			group "root"
			mode 0600
			variables({
				:kerb_domain => node[:kerberos][:domain],
				:kerb_servers => node[:kerberos][:servers],
				:kerb_admin_server => node[:kerberos][:admin_server]
			})
			notifies :run, "execute[preseed-krb5-config]", :immediately
		end

		package "libpam-krb5" do
			action :install
		end

		# runs a dpg-reconfigure to make sure this machine has the latest /etc/krb5.conf setup
		execute "reconfig-krb5-config" do
			command "dpkg-reconfigure -f noninteractive krb5-config"
			action :nothing
		end

	end
end
