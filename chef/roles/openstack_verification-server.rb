name "openstack_verification-server"
description "Openstack verification Server Role"
run_list(
         "recipe[openstack_verification]"
)
default_attributes()
override_attributes()

