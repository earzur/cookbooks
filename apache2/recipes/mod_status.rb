#
# Cookbook Name:: apache2
# Recipe:: status 
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

apache_module "status" do
  conf true
  cacti_servers do
    ## find every nodes with the 'cacti' tag and build a comma-separated
    ## list of their ip addresses, used to restrict usage of the cacti
    ## private key to those IP addresses
    ## the [0..-2] is there to remove the last comma from the list
    ## see man 8 sshd for informations about the authorized_keys file format
    search(:node, "tags:cacti").inject('') do |val,n|
      val << n.ipaddress + ","
    end[0..-2]
  end
end
