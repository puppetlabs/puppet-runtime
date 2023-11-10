component "post-additional-rubies" do |pkg, settings, platform|
  pkg.build do
    [ "rm -rf #{settings[:prefix]}/include/openssl",
      "mv /tmp/openssl #{settings[:prefix]}/include/openssl"]
  end
end
