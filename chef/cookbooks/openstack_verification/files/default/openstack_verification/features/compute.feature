@compute
Feature: Compute OpenStack
In order to see if Compute is functional
as an Admin
I want to use some basic compute functions

Scenario: Start a server
	Given a running OpenStack system
	 When I start a VM with flavor "m1.tiny", image "test-image" and name "sample-server"
	 And I request the VMs list
	 Then I should be able to see these VMs
	  | Name 	      | Status |
	  | sample-server | BUILD  |

Scenario: Start and stop a server server
	Given a running OpenStack system
	  And I start a VM with flavor "m1.tiny", image "test-image" and name "sample-server"
	 When I shut down the server "sample-server"
	  And I request the VMs list
	 Then I should be able to see these VMs
	  | Name 	      | Status |