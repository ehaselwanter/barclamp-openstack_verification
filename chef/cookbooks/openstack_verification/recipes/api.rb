#
# Cookbook Name:: glance
# Recipe:: api
#
#

include_recipe "#{@cookbook_name}::common"

openstack_verification_service "api"

node[:openstack_verification][:monitor][:svcs] <<["openstack_verification-api"]

