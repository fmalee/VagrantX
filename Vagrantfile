require 'json'
require 'yaml'

VAGRANTFILE_API_VERSION = "2"
homeDir = File.expand_path("~/.vagrantX")
confDir = File.dirname(__FILE__) + '/vagrant.d'

vagrantYamlPath = confDir + "/Vagrant.yaml"
vagrantJsonPath = confDir + "/Vagrant.json"
if (! File.exists? vagrantYamlPath) & (! File.exists? vagrantJsonPath) then
    confDir = homeDir
end

vagrantYamlPath = confDir + "/Vagrant.yaml"
vagrantJsonPath = confDir + "/Vagrant.json"
afterScriptPath = confDir + "/after.sh"
aliasesPath = confDir + "/aliases"

require File.expand_path(homeDir + '/scripts/vagrantX.rb')

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    if File.exists? aliasesPath then
        config.vm.provision "file", source: aliasesPath, destination: "~/.bash_aliases"
    end

    if File.exists? vagrantYamlPath then
        settings = YAML::load(File.read(vagrantYamlPath))
    elsif File.exists? vagrantJsonPath then
        settings = JSON.parse(File.read(vagrantJsonPath))
    end

    VagrantX.configure(config, settings)

    if File.exists? afterScriptPath then
        config.vm.provision "shell", path: afterScriptPath
    end

    if defined? VagrantPlugins::HostsUpdater
        config.hostsupdater.aliases = settings['sites'].map { |site| site['map'] }
    end
end
