Feature: Basic OpenStack avablity
In order to see if Openstack is OpenStack
as an Admin
I want to use some basic API functions

Scenario: Create and List flavor types
	Given the following flavors
	  | Name 	   | Memory  | Disk  |   VCPU  |
	  | Testflavor | 256     |  10   |   1     |
	 When I request the flavor list
	 Then I should be able to see the flavors
	  | Name 	   | Memory  | Disk  |   VCPU  |
	  | Testflavor | 256     |  10   |   1     |


Scenario: Create and List image types
	Given the following flavors
	  | Name 	   |
	  | Test image |
	 When I request the image list
	 Then I should be able to see the images
	  | Name 	   |
	  | Test image |

Scenario: Empty server list
	Given a running OpenStack system
	 When I request the VMs list
	 Then I should be able to see these VMs
	  | Name 	      | Status |

Scenario: Start a server
	Given a running OpenStack system
	 When I start a VM with flavor "Testflavor", image "Test image" and name "sample-server"
	 And I request the VMs list
	 Then I should be able to see these VMs
	  | Name 	      | Status |
	  | sample-server | BUILD  |

Scenario: Start and stop a server server
	Given a running OpenStack system
	  And I start a VM with flavor "Testflavor", image "Test image" and name "sample-server"
	 When I stop the VM with name "sample-server"
	  And I request the VMs list
	 Then I should be able to see these VMs
	  | Name 	      | Status |