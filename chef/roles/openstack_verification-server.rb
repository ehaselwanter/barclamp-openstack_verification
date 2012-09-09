name "openstack_verification-server"
description "Openstack verification Server Role"
run_list(
         "recipe[openstack_verification::api]",
         "recipe[openstack_verification::monitor]"
)
default_attributes()
override_attributes()

