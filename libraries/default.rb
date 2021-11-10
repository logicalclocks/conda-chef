class CondaHelpers
  def initialize(node)
    @node = node
  end

  def is_upgrade
    not @node['install']['current_version'].empty?
  end

  def bind_services_private_ip
    @node['install']['bind_services_private_ip'].strip.casecmp?('true')
  end

  def get_user_home(login_username)
    begin
      return ::Dir.home login_username
    rescue
      homes = @node['install']['homes_directory']
      if homes.empty?
        raise "Attribute install/homes_directory cannot be empty"
      end
      return ::File.join(homes, login_username)
    end
  end

end

class Chef
  class Recipe
    def conda_helpers
      CondaHelpers.new(node)
    end
  end
  
  class Resource
    def conda_helpers
      CondaHelpers.new(node)
    end
  end
end
