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
	  | sample-server | ACTIVE |
  
Scenario: Stop a running VM
    Given a running VM named "sample-server"
    When I shut down the server "sample-server"
    Then the server "sample-server" should be shut down

Scenario: Start and stop a server server
	Given a running OpenStack system
	  And I start a VM with flavor "m1.tiny", image "test-image" and name "sample-server-2"
	 When I shut down the server "sample-server-2"
	  And I request the VMs list
	 Then I should be able to see these VMs
	  | Name 	      | Status |