@volumes
Feature: Openstack volumes
In order to persist my data outside of VMs
as a OpenStackUser
I want to manage volumes

Scenario: Create and delete volume
	Given a volume with name "testvol3" and size "1" gigabyte
	  And the volume "testvol3" is in status "available" after "60" seconds
	 When I delete the volume with name "testvol3"
	 Then there should be no volume with name "testvol3"

Scenario: Write data to volume
	Given a running server "m1.tiny" with image "test-image" and name "test1"
	  And a volume with name "testvol1" and size "1" gigabyte
	  And the volume "testvol1" is in status "available" after "60" seconds
	  And I attach the volume "testvol1" to server "test1"
	 Then there should be volumes
	  | Name 	      | Size  |
	  | testvol1      | 1     |
#
#	When I log in to the server
#	  And mount the volume
#	  And write a file to the volume
#	Then I should be be able to read the file again
#

Scenario: Detach volume from server
	Given a running server "m1.tiny" with image "test-image" and name "test1"
	  And a volume with name "testvol2" and size "1" gigabyte
	  And the volume "testvol2" is in status "available" after "60" seconds
	  And I attach the volume "testvol2" to server "test1"
	 When I shut down the server "test1"
	  And detach the volume "testvol2" (3 times)
	  And I shut down the server "test1"
	 Then the server "test1" should be shut down
	  And the volume "testvol2" should be detached



Scenario: Create and delete really big volume
	Given a volume with name "testvol4" and size "1" gigabyte
	  And the volume "testvol4" is in status "available" after "60" seconds
	 When I delete the volume with name "testvol4"
	 Then there should be no volumes
#
#Scenario: Create volume and create bigger snapshot from it
#	Given a volume with name "testvol1" and size "1" gigabyte
#	  And the volume "testvol1" is in status "available" after "60" seconds
#	 When I create a snapshot "testsnap" from "testvol1"
#	  And I create a volume with "2" gigabytes and name "from snapshot" from snapshot "testsnap"
#	 Then there should be volumes
#	  | Name 	      | Size  |
#	  | testvol1      | 1     |
#	  | from snapshot | 2     |
