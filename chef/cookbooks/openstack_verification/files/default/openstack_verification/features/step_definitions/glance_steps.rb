Given /^there is no image named "(.*?)"$/ do |image_name|
  raise "image already uploaded" if glance_find_image_by_name(image_name).size > 1
end

When /^I upload a "(.*?)" image named "(.*?)" with disk format "(.*?)" and container format "(.*?)"$/ do |public, name, disk_format, container_format|

  path_to_disk_images = ENV['HOME']
  image_to_upload = File.join(path_to_disk_images,name)
  new_image = glance.create_image(
  :name => name,
  :is_public => public.eql?("public"),
  :container_format => container_format,
  :disk_format => disk_format,
  :location => image_to_upload,
  :size => File.size(image_to_upload)
  )

  raise "upload failed" if new_image.status.to_s.match(/20?/)
end

Then /^I should see a image named "(.*?)" in the list of images$/ do |image_name|
  glance_find_image_by_name(image_name).size > 1
end

def glance_find_image_by_name(name)
  glance.list_public_images.body['images'].select{|item| item['name'] == image_name}
end

def glance()
  @glance ||= Fog::Image.new(:provider => :OpenStack)
end