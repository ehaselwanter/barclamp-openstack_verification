# Copyright 2012, Edmund Haselwanter 
# 
# Licensed under the Apache License, Version 2.0 (the "License"); 
# you may not use this file except in compliance with the License. 
# You may obtain a copy of the License at 
# 
#  http://www.apache.org/licenses/LICENSE-2.0 
# 
# Unless required by applicable law or agreed to in writing, software 
# distributed under the License is distributed on an "AS IS" BASIS, 
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
# See the License for the specific language governing permissions and 
# limitations under the License. 
# 

class OpenstackVerificationService < ServiceObject

  def initialize(thelogger)
    @bc_name = "openstack_verification"
    @logger = thelogger
  end
  
  #if barclamp allows multiple proposals OVERRIDE
  # def self.allow_multiple_proposals?
  
  def create_proposal
    @logger.debug("Openstack verification create_proposal: entering")
    base = super

    nodes = NodeObject.all
    nodes.delete_if { |n| n.nil? or n.admin? }
    if nodes.size >= 1
      base["deployment"]["openstack_verification"]["elements"] = {
        "openstack_verification-server" => [ nodes.first[:fqdn] ]
      }
    end

    @logger.debug("Openstack verification create_proposal: exiting")
    base
  end

  def apply_role_pre_chef_call(old_role, role, all_nodes)
    @logger.debug("Openstack verification apply_role_pre_chef_call: entering #{all_nodes.inspect}")
    return if all_nodes.empty?

    # Make sure the bind hosts are in the admin network
    all_nodes.each do |n|
      node = NodeObject.find_node_by_name n

      admin_address = node.get_network_by_type("admin")["address"]
      node.crowbar[:openstack_verification] = {} if node.crowbar[:openstack_verification].nil?
      node.crowbar[:openstack_verification][:api_bind_host] = admin_address

      node.save
    end
    @logger.debug("Openstack verification apply_role_pre_chef_call: leaving")
  end

end

