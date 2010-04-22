module ActionController
  module Resources
    class Resource

      # Redefining methods from /usr/lib/ruby/gems/1.8/gems/actionpack-2.3.4/lib/action_controller/resources.rb so that the RESTful routes accept member_path option

      def member_path
        @member_path || options[:member_path] || "#{shallow_path_prefix}/#{path_segment}/:id"
      end

      def nesting_path_prefix
        @nesting_path_prefix || options[:member_path] || "#{shallow_path_prefix}/#{path_segment}/:#{singular}_id"
      end

      def requirements(with_id = false)
        @requirements   ||= @options[:requirements] || {}
        @id_requirement ||= options[:member_path].blank? ? { :id => @requirements.delete(:id) || /[^#{Routing::SEPARATORS.join}]+/ } : options[:member_path_requirements] || {}

        with_id ? @requirements.merge(@id_requirement) : @requirements
      end
    end
  end
end
