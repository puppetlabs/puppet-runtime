platform "redhatfips-8-x86_64" do |plat|
  plat.inherit_from_default
  packages = ["python3.11"]
  plat.provision_with "dnf install -y --allowerasing #{packages.join(' ')}"
end
