#
# Cookbook Name:: ndsu-openstack
# Recipe:: prenova
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

newNovaId = 500


# setup a nova user before the packaging system uses the next available UID
user "nova" do
	comment "nova-compute user"
	uid newNovaId
	shell "/bin/bash"
	home "/var/lib/nova"
	gid "nogroup"
	supports :manage_home => true
	action :nothing # do nothing - this is function prototype
end


if node[:etc][:passwd][:nova]

	oldnova = node[:etc][:passwd][:nova][:uid]
	puts "oldNovaId: #{oldnova}"
	puts "newNovaId: #{newNovaId}"

	if oldnova != newNovaId

		# stop the services running as nova
		service "nova-compute" do
			action :stop
		end


		execute "try-usermod-nova" do
			command "sleep 1"
			action :run
			notifies :create, resources( :user => "nova"), :immediately
		end

		# do a global chown on files to the new nova user
		# start nova-compute after
		execute "chown-nova-files" do
			command "find / -user #{oldnova} -print0 | xargs -0 chown -h #{newNovaId}"
			action :run
			notifies :start, resources( :service => "nova-compute"), :immediately
		end
	end
else

	execute "make-nova-user" do
		command "sleep 1"
		action :run
		notifies :create, resources( :user => "nova"), :immediately
	end

end

# setup nova gluster group
group "nova-gluster" do
	gid 2000
	members ['nova']
end


