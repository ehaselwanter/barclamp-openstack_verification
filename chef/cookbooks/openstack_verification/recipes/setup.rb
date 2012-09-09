#
# Cookbook Name:: Openstack verification
# Recipe:: setup
#

include_recipe "#{@cookbook_name}::common"

bash "tty linux setup" do
  cwd "/tmp"
  user "root"
  code <<-EOH
	mkdir -p /var/lib/openstack_verification/
	curl #{node[:openstack_verification][:tty_linux_image]} | tar xvz -C /tmp/
	touch /var/lib/openstack_verification/tty_setup
  EOH
  not_if do File.exists?("/var/lib/openstack_verification/tty_setup") end
end
