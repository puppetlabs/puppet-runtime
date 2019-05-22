module Gem
  class << self
    ##
    # Remove methods we are going to override. This avoids "method redefined;"
    # warnings otherwise issued by Ruby.

    remove_method :default_path if method_defined? :default_path

    def puppet_vendor_dir
      path = if defined? RUBY_FRAMEWORK_VERSION then
               [
                   File.dirname(RbConfig::CONFIG['sitedir']),
                   'VendorGems'
               ]
             elsif RbConfig::CONFIG['rubylibprefix'] then
               [
                   RbConfig::CONFIG['rubylibprefix'],
                   'vendor_gems',
               ]
             else
               [
                   RbConfig::CONFIG['libdir'],
                   'ruby',
                   'vendor_gems',
               ]
             end

      @puppet_vendor_dir ||= File.join(*path)
    end

    def default_path
      path = []
      path << user_dir if user_home && File.exist?(user_home)
      path << default_dir
      path << puppet_vendor_dir
      path << vendor_dir if vendor_dir and File.directory? vendor_dir
      path
    end
  end
end
