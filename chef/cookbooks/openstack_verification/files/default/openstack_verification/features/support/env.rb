require 'fog'
require 'timeout'
require 'rspec/expectations'

PATH_TO_TEST_IMAGES = ENV['HOME']
TEST_IMAGE_NAME = "test-image"

def openstack()
  @openstack ||= Fog::Compute.new(:provider => "OpenStack")
end

def glance()
  @glance ||= Fog::Image.new(:provider => :OpenStack)
end

def cleanup_openstack

  # FIXXME : We really should wait if it can do its thing ...
  openstack.reload
  openstack.servers.each do |s|
    begin
      puts "cleanup server #{s.id}"
      s.destroy unless s.state == "DELETED"
    rescue
      puts "cleanup throw an error #{s.inspect}"
    end
  end

  openstack.snapshots.each do |s|
    begin
      puts "cleanup snapshot #{s.id}"
      s.destroy
    rescue
      puts "cleanup snapshots throw an error for #{s.inspect}"
    end
  end

  openstack.volumes.each do |v|
    begin
      puts "cleanup volume #{v.id}"
      v.wait_for(10){|vol| ['available','error'].include? vol.status}
      v.destroy
    rescue
      puts "cleanup throw an error for #{v.inspect}"
    end
   end
end

at_exit do
  # be aware that this is a API -> it will do stuff asynchronous
  cleanup_openstack
end