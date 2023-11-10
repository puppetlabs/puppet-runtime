component "pre-additional-rubies" do |pkg, settings, platform|
  pkg.build do
    ["mv #{settings[:prefix]}/include/openssl /tmp/openssl"]
  end
end
