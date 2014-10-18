require 'dispatcher' unless Rails::VERSION::MAJOR >= 3
require_dependency 'members_controller'

module RedmineAllocation
  module Patches
    module MembersControllerPatch
      def self.included(base) # :nodoc:
        base.extend(ClassMethods)
        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable  # Send unloadable so it will be reloaded in development

          append_before_filter :update_allocation, :only => [:update, :edit]
        end
      end

      module InstanceMethods
        def update_allocation
          if params[:allocation]
            @member.attributes = params[:allocation]
          end
        end
      end

      module ClassMethods
      end
    end
  end
end

if Rails::VERSION::MAJOR >= 3
  ActionDispatch::Callbacks.to_prepare do
    MembersController.send(:include, RedmineAllocation::Patches::MembersControllerPatch)
  end
else
  Dispatcher.to_prepare do
    MembersController.send(:include, RedmineAllocation::Patches::MembersControllerPatch)
  end
end
