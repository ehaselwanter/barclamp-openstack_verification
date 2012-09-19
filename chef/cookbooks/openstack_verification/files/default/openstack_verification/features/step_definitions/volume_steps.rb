Given /^a running server "(.*?)" with image "(.*?)" and name "(.*?)"$/ do |flavor_name, image_name, server_name|

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

Given /^a volume with name "(.*?)" and size "(.*?)" gigabyte$/ do |vol_name, size|
  openstack.volumes.create({ :name => vol_name, :size => size.to_i, :description => "#{vol_name} Volume"})
end

Given /^the volume "(.*?)" is in status "(.*?)" after "(.*?)" seconds$/ do |volume_name, status, timeout|
  volume = openstack.volumes.find { |v| v.name == volume_name }
  volume.wait_for(timeout.to_i) { volume.status == status }
end

Given /^I attach the volume "(.*?)" to server "(.*?)"$/ do |volume_name, server_name|
  server = openstack.servers.find { |s| s.name == server_name }
  volume = volume_by_name(volume_name)
  volume.attach(server.id, "/dev/vdc")
  volume.wait_for { volume.status == "in-use" }
end

Then /^there should be volumes$/ do |table|
  data = table.raw.last(table.raw.size-1)
  openstack.volumes.each_with_index do |volume, index|
    volume.name.should == data[index][0]
    volume.size.to_s.should == data[index][1].to_s
  end
end

When /^detach the volume "(.*?)" \((\d+) times\)$/ do |volume_name, number|
  volume = volume_by_name(volume_name)
  attachment = volume.attachments.last
  number.to_i.times do
    volume.detach(attachment["serverId"], attachment["id"])
  end
end

Then /^the volume "(.*?)" should be detached$/ do|volume_name|
  volume = volume_by_name(volume_name)
  volume.status.should == "available"
end

When /^I delete the volume with name "(.*?)"$/ do |volume_name|
  volume = volume_by_name(volume_name)
  volume.destroy
  wait_for_delete_without_error(volume)
end

Then /^there should be no volumes$/ do
  openstack.reload
  openstack.volumes.size.should == 0
end

Then /^there should be no volume with name "(.*?)"$/ do |volume_name|
  volume_by_name(volume_name).should be_nil
end

When /^I create a snapshot "(.*?)" from "(.*?)"$/ do |snap_name, volume_name|
  volume = volume_by_name(volume_name)
  openstack.create_volume_snapshot(volume.id, snap_name, snap_name)
  snapshot = snap_by_name(snap_name)
  snapshot.wait_for { snapshot.status == "available" }
end

When /^I create a volume with "(.*?)" gigabytes and name "(.*?)" from snapshot "(.*?)"$/ do |size, vol_name, snap_name|
  snapshot = snap_by_name(snap_name)
  volume = openstack.volumes.create({ :name => vol_name, :size => size.to_i, :description => "#{vol_name} Volume", :snapshot_id =>  snapshot.id })
  volume.wait_for { volume.status == "available" }
end

def volume_by_name(volume_name)
  openstack.volumes.find { |v| v.name == volume_name }
end

def snap_by_name(snap_name)
  openstack.snapshots.find {|s| s.name == snap_name }
end

def server_by_name(server_name)
  openstack.servers.find {|s| s.name == server_name }
end


def wait_for_delete_without_error(volume_or_snap)
  begin
      volume_or_snap.wait_for { volume_or_snap.status != "deleting" }
  rescue Fog::Errors::Error
      # When volume is gone there will be an fog error.
      # A better solution should be found
  end
end

After('@volume') do
  # see
end
