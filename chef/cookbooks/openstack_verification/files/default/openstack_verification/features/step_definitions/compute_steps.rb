When /^I start a VM with flavor "(.*?)", image "(.*?)" and name "(.*?)"$/ do |flavor_name, image_name, server_name|
  flavor = openstack.flavors.find { |f| f.name == flavor_name}
  image = openstack.images.find  { |i| i.name == image_name }
  server = openstack.servers.create(
  :name => server_name,
  :flavor_ref => flavor.id,
  :image_ref => image.id,
  :username => 'ubuntu'
  )
  server.wait_for { ready? }
end

When /^I shut down the server "(.*?)"$/ do |name|
  server = server_by_name(name)
  server.destroy
end

Then /^the server "(.*?)" should be shut down$/ do |name|
  server = server_by_name(name)
  begin
    server.wait_for { server.state != "ACTIVE" }
  rescue Fog::Errors::Error
    #
  end
  server = server_by_name(name)

  server.should == nil
end



