# Define default CFLAGS and LDFLAGS for most platforms, and then
# tweak or adjust them as needed.
proj.setting(:cppflags, "-I#{proj.includedir} -I/opt/pl-build-tools/include")
proj.setting(:cflags, "#{proj.cppflags}")
proj.setting(:ldflags, "-L#{proj.libdir} -L/opt/pl-build-tools/lib -Wl,-rpath=#{proj.libdir}")

# Platform specific overrides or settings, which may override the defaults

# Harden Linux ELF binaries by compiling with PIE (Position Independent Executables) support,
# stack canary and full RELRO.
# We only do this on platforms that use their default OS toolchain since pl-gcc versions
# are too old to support these flags.

if((platform.is_sles? && platform.os_version.to_i >= 15) ||
      (platform.is_el? && platform.os_version.to_i == 8 && platform.architecture !~ /ppc64/) ||
      (platform.is_debian? && platform.os_version.to_i >= 10) ||
      (platform.is_ubuntu? && platform.os_version.to_i >= 22) ||
      platform.is_fedora?
    )
  proj.setting(:supports_pie, true)
  proj.setting(:cppflags, "-I#{proj.includedir} -D_FORTIFY_SOURCE=2")
  proj.setting(:cflags, '-fstack-protector-strong -fno-plt -O2')
  proj.setting(:ldflags, "-L#{proj.libdir} -Wl,-rpath=#{proj.libdir},-z,relro,-z,now")
end