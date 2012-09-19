Given /^the following flavors$/ do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end

When /^I request the flavor list$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should be able to see the flavors$/ do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end

When /^I request the image list$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should be able to see the images$/ do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end

Given /^a running OpenStack system$/ do

  # FIXXME: refactor this one to make it more reusable

  if glance_find_images_by_name(TEST_IMAGE_NAME).size < 1

    image_to_upload = File.join(PATH_TO_TEST_IMAGES,"cirros-0.3.0-x86_64-vmlinuz")

    kernel = glance.create_image(
      :name => "#{TEST_IMAGE_NAME}-vmlinuz",
      :is_public => true,
      :container_format => "aki",
      :disk_format => "aki",
      :location => image_to_upload,
      :size => File.size(image_to_upload)
    )

    image_to_upload = File.join(PATH_TO_TEST_IMAGES,"cirros-0.3.0-x86_64-initrd")

    initrd = glance.create_image(
      :name => "#{TEST_IMAGE_NAME}-initrd",
      :is_public => true,
      :container_format => "ari",
      :disk_format => "ari",
      :location => image_to_upload,
      :size => File.size(image_to_upload)
    )

    image_to_upload = File.join(PATH_TO_TEST_IMAGES,"cirros-0.3.0-x86_64-blank.img")

    glance.create_image(
      :name => TEST_IMAGE_NAME,
      :is_public => true,
      :container_format => "ami",
      :disk_format => "ami",
      :location => image_to_upload,
      :size => File.size(image_to_upload),
      :properties => {
        :kernel_id => kernel.body["image"]["id"],
        :ramdisk_id => initrd.body["image"]["id"]
    })
  end

  glance_find_images_by_name(TEST_IMAGE_NAME).size.should be 1

end

When /^I request the VMs list$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should be able to see these VMs$/ do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end

