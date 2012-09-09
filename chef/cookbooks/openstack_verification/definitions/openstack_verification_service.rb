define :openstack_verification_service do

  openstack_verification_name="openstack_verification-#{params[:name]}"

  service openstack_verification_name do
    if (platform?("ubuntu") && node.platform_version.to_f >= 10.04)
      restart_command "restart #{openstack_verification_name}"
      stop_command "stop #{openstack_verification_name}"
      start_command "start #{openstack_verification_name}"
      status_command "status #{openstack_verification_name} | cut -d' ' -f2 | cut -d'/' -f1 | grep start"
    end
    supports :status => true, :restart => true
    action [:enable, :start]
    subscribes :restart, resources(:template => node[:openstack_verification][:config_file])
  end

end
