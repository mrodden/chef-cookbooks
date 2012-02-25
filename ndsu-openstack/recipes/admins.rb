#
# Cookbook Name:: libpam-krb5
# Recipe:: admins
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


include_recipe "libpam-krb5::libpam-krb5"


# Load the keys of the items in the 'admins' data bag
admins = data_bag('admins')

admins.each do |login|
	# This causes a round-trip to the server for each admin in the data bag
	admin = data_bag_item('admins', login)
	home = "/home/#{login}"

	# for each admin in the data bag, make a user resource
	# to ensure they exist
	user(login) do
		#uid       admin['uid']
		gid       node[:etc][:group][:users][:gid]
		shell      "/bin/bash"
		#comment   admin['comment']

		home      home
		supports  :manage_home => true
	end
end

# put members into admin group (gives sudoer access on ubuntu)
group "admin" do
	# set memebers to array 'admins' from databag
	members admins
	action :manage
end
