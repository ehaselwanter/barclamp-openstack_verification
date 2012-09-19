@glance
Feature: OpenStack Image Repository use cases

  As a Openstack user
  I want to be able to upload my operating system files
  So that I can start virtual instances based on this images

Scenario: Empty server list
  Given a running OpenStack system
    When I request the VMs list
    Then I should be able to see these VMs
  	  | Name 	      | Status |

Scenario: upload kernel
  Given there is no image named "cirros-0.3.0-x86_64-vmlinuz"
  When I upload a "public" image named "cirros-0.3.0-x86_64-vmlinuz" with disk format "aki" and container format "aki"
  Then I should see a image named "cirros-0.3.0-x86_64-vmlinuz" in the list of images

Scenario: upload ramdisk
  Given there is no image named "cirros-0.3.0-x86_64-initrd"
  When I upload a "public" image named "cirros-0.3.0-x86_64-initrd" with disk format "ari" and container format "ari"
  Then I should see a image named "cirros-0.3.0-x86_64-initrd" in the list of images

Scenario: upload disk image
  Given there is no image named "cirros-0.3.0-x86_64-blank.img"
  When I upload a "public" image named "cirros-0.3.0-x86_64-blank.img" with disk format "ari" and container format "ari"
  Then I should see a image named "cirros-0.3.0-x86_64-blank.img" in the list of images

Scenario: define a new image
  Given there is kernel named "cirros-0.3.0-x86_64-vmlinuz" and a ramdisk named "cirros-0.3.0-x86_64-initrd"
  When I assign the kernel "cirros-0.3.0-x86_64-vmlinuz" and the ramdisk "cirros-0.3.0-x86_64-initrd" to the image "cirros-0.3.0-x86_64-blank.img"
  Then I should see a kernel and ramdisk assigned to the image "cirros-0.3.0-x86_64-blank.img"

Scenario: Create and List image types
 Given the following flavors
   | Name 	   |
   | Test image |
 When I request the image list
 Then I should be able to see the images
   | Name 	   |
   | Test image |

