#
# Cookbook Name:: apache2
# Recipe:: dav_svn 
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

case node[:platform]
when "centos","redhat","fedora","suse"
  package "mod_dav_svn"
  
  file "/etc/httpd/conf.d/subversion.conf" do
    action [:delete]
  end
  
  cookbook_file "/etc/httpd/mods-available/dav_svn.load" do
    source "dav_svn.load"
    owner "root"
    group "root"
    mode "0644"
  end
else
  package "libapache2-svn"
end 

apache_module "dav_svn"
