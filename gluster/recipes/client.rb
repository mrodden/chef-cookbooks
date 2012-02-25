#
# Cookbook Name:: gluster
# Recipe:: default
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

# install the gluster client
package "glusterfs-client" do
	action :install
end

# build mount directory
directory "/var/lib/nova/instances" do
	not_if {File.exists?("/var/lib/nova/instances")}
	action :create
end

# mount gluster share
mount "/var/lib/nova/instances" do
	device "pyxis:/nova-images"
	options "defaults,_netdev"
	fstype "glusterfs"
	action [:mount, :enable]
end
