# workaround the inability to modify built-in core redmine permissions once set

module Redmine
  module AccessControl
    class Permission
      def enhance(hash)
        hash.each do |controller, actions|
          if actions.is_a? Array
            @actions << actions.collect {|action| "#{controller}/#{action}"}
          else
            @actions << "#{controller}/#{actions}"
          end
          @actions.flatten!
        end
      end
    end
  end
end
