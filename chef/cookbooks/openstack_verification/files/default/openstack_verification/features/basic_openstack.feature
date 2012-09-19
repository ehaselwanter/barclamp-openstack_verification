@basic
Feature: Basic OpenStack avablity
In order to see if Openstack is OpenStack
as an Admin
I want to use some basic API functions

Scenario: Create and List flavor types
	Given the following flavors
	  | Name 	   | Memory  | Disk  |   VCPU  |
	  | Testflavor | 256     |  1   |   1     |
	 When I request the flavor list
	 Then I should be able to see the flavors
	  | Name 	   | Memory  | Disk  |   VCPU  |
	  | Testflavor | 256     |  1   |   1     |
