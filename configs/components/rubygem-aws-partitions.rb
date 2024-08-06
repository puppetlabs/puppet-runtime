component "rubygem-aws-partitions" do |pkg, settings, platform|
  version = settings[:rubygem_aws_partitions_version] || '1.961.0'
  pkg.version version

  case version
  when '1.961.0'
    pkg.md5sum '7eeac993d4834a02a9c125cde78363c0'
  when '1.962.0'
    pkg.md5sum '41189f42dc83691fdfa8153e4dbf988d'
  else
    raise "rubygem-aws-partitions #{version} has not been configured; Cannot continue."
  end

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
