module RedmineDocumentFolders
  module Patches

    module ProjectsControllerPatch

      def self.included(base)
        base.extend(ClassMethods)
        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable
        end
      end

      module ClassMethods
      end

      module InstanceMethods
      end

    end
  end
end
