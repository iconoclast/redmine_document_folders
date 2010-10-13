module RedmineDocumentFolders
  module Patches
    module DocumentPatch

      def self.included(base)
        base.extend(ClassMethods)
        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable
          belongs_to :folder
        end
      end

      module ClassMethods
      end

      module InstanceMethods
      end

    end
  end
end
