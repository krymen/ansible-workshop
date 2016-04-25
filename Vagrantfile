Vagrant.configure(2) do |config|
  (1..2).each do |i|
    config.vm.define "node-#{i}" do |d|
      d.vm.box = "ubuntu/trusty64"
      d.vm.hostname = "node-#{i}"
      d.vm.network "private_network", ip: "10.100.192.20#{i}"

      d.vm.provider "virtualbox" do |v|
        v.memory = 1024
        v.linked_clone = true if Vagrant::VERSION =~ /^1.8/
      end

      d.ssh.insert_key = false
    end
  end
end
