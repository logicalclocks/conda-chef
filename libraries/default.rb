class CondaHelpers
  def initialize(node)
    @node = node
  end

  def is_upgrade
    not @node['install']['current_version'].empty?
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
