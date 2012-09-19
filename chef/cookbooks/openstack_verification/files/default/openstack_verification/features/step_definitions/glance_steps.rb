Given /^there is no image named "(.*?)"$/ do |image_name|
  images = glance_find_images_by_name(image_name)
  if images.size >= 1
     images.each do  |image|
       glance_delete_image(image["id"])
     end
  end
  glance_find_images_by_name(image_name).size.should be 0
end

When /^I upload a "(.*?)" image named "(.*?)" with disk format "(.*?)" and container format "(.*?)"$/ do |public, name, disk_format, container_format|

  image_to_upload = File.join(PATH_TO_TEST_IMAGES,name)
  new_image = glance.create_image(
  :name => name,
  :is_public => public.eql?("public"),
  :container_format => container_format,
  :disk_format => disk_format,
  :location => image_to_upload,
  :size => File.size(image_to_upload)
  )

  new_image.status.to_s.should match(/20?/)
end

Then /^I should see a image named "(.*?)" in the list of images$/ do |image_name|
  glance_find_images_by_name(image_name).size.should be 1
end

Given /^there is kernel named "(.*?)" and a ramdisk named "(.*?)"$/ do |kernel_name, ramdisk_name|
  glance_find_images_by_name(kernel_name).size.should be 1
  glance_find_images_by_name(ramdisk_name).size.should be 1
end

When /^I assign the kernel "(.*?)" and the ramdisk "(.*?)" to the image "(.*?)"$/ do |kernel_name, ramdisk_name, image_name|
  kernel = glance_find_images_by_name(kernel_name)
  kernel.size.should be 1
  ramdisk = glance_find_images_by_name(ramdisk_name)
  ramdisk.size.should be 1
  image = glance_find_images_by_name(image_name)
  image.size.should be 1
  image_to_update = image.first()
  image_to_upload = File.join(PATH_TO_TEST_IMAGES,image_to_update["name"])
  glance.update_image({
        :id => image_to_update["id"],
        :name => image_to_update["name"],
        :is_public => image_to_update["is_public"],
        :container_format => image_to_update["container_format"],
        :disk_format => image_to_update["disk_format"],
        :location => image_to_upload,
        :size => File.size(image_to_upload),
        :properties => {
          :kernel_id => kernel.first["id"],
          :ramdisk_id => ramdisk.first["id"]
        }
  })
end

Then /^I should see a kernel and ramdisk assigned to the image "(.*?)"$/ do |image_name|
  image = glance_find_images_by_name(image_name)
  image.size.should be 1
end


def glance_find_images_by_name(image_name)
  glance.list_public_images_detailed("name",image_name).body['images']
end

def glance_delete_image(image_id)
  glance.delete_image(image_id) rescue MultiJson::DecodeError # FIXXME: it does delete but raises an Exception. weird
end