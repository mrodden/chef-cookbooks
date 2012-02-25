Description
===========

This cookbook has recipes for setting up krb5-config and libpam-krb5 for ubuntu/debian installs.
There is also an admins recipe for setting up new password-less users and adding them to the admin group (in ubuntu, this makes them sudoers)

Admin users are pulled from the admins databag, the ID values of objects inside admins are used as login names. Currently no other values are set from the bag values, defaults are to next uid, gid=100, /home/<username> for home and /bin/bash as a shell. They are then added to the admin usergroup.

Requirements
============

tested with chef-0.10 so you probably need that...

Attributes
==========

no attributes are currently used. everything is set in libpam-krb5.rb or the admins databag

Usage
=====

1. put your admins in the admins databag (which you will probably need to make)
2. change the kerb_domain, kerb_servers and kerb_admin_server values in libpam-krb5.rb

