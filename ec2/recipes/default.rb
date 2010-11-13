#l
# Cookbook Name:: ec2
# Recipe:: default
#
# Copyright 2008-2009, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
if node[:ec2]
  
  unless node[:ec2opts][:formatting_done]

    instance_type = node[:ec2][:instance_type]
    
    if node[:ec2opts][:lvm][:ephemeral_devices][instance_type]
      template "/tmp/lvm_ephemeral.rb" do
        source "lvm_ephemeral.rb.erb"
        owner "root"
        group "root"
        mode "0755"
        backup false
        variables({
          :ephemeral_devices => node[:ec2opts][:lvm][:ephemeral_devices][instance_type],
          :ephemeral_volume_group => node[:ec2opts][:lvm][:ephemeral_volume_group],
          :ephemeral_logical_volume => node[:ec2opts][:lvm][:ephemeral_logical_volume],
        })
      end
        
      mount "/mnt" do
        device "/dev/null"
        action [:umount,:disable]
      end
    
      execute "/tmp/lvm_ephemeral.rb" do
        creates "/dev/#{node[:ec2opts][:lvm][:ephemeral_volume_group]}/#{node[:ec2opts][:lvm][:ephemeral_logical_volume]}"
        action :run
      end
     
      mount "/mnt" do
        device "/dev/#{node[:ec2opts][:lvm][:ephemeral_volume_group]}/#{node[:ec2opts][:lvm][:ephemeral_logical_volume]}"
        fstype "xfs"
        options "rw"
        action [:mount,:enable]
      end
    
      execute "swapon" do
        command "/sbin/swapon /dev/#{node[:ec2opts][:lvm][:ephemeral_volume_group]}/swap"
        not_if "grep #{node[:ec2opts][:lvm][:ephemeral_volume_group]}-swap /proc/swaps"
        action :run
      end
    
      execute "swap_to_fstab" do
        command "echo /dev/#{node[:ec2opts][:lvm][:ephemeral_volume_group]}/swap none swap default 0 0 >> /etc/fstab"
        not_if "grep /dev/#{node[:ec2opts][:lvm][:ephemeral_volume_group]}/swap /etc/fstab"
      end
      node[:ec2ops] ||= Mash.new
      node[:ec2ops][:formatting_done] = true
    end
  end
end
  