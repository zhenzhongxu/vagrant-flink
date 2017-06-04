vagrant-flink
============================
Currently supporting Apache Flink 1.2.1.

# 1. Basics
### Vagrant project to spin up a cluster of 2 task manager nodes and 1 job manager node, residing on 64-bit Ubuntu Trusty Linux virtual machines
Ideal for development cluster on a laptop with at least 8GB of memory.

# 2. Prerequisites
1. At least 1GB memory for each VM node.
2. Vagrant [latest version]
3. VirtualBox [latest version]

# 3. Getting Started
1. [Download and install VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. [Download and install Vagrant](http://www.vagrantup.com/downloads.html).
3. Run ```vagrant box add ubuntu/trusty64```
4. Git clone this project, and change directory (cd) into this project (directory).
8. Run ```./start-cluster.sh``` to create the VMs.
9. Run ```vagrant ssh jobmanager``` to get into your job manager VM.
   Run ```vagrant ssh taskmanager-0[0-2]``` to get into your job manager VM.
10. Run ```vagrant destroy``` when you want to destroy all VMs or trying to start from refresh.

# 4. Job Manager UI
  http://localhost:8081


# 5. Copyright
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
