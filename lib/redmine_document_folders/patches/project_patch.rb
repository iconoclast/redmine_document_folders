module RedmineDocumentFolders
  module Patches

    module ProjectPatch

      def self.included(base)
        base.extend(ClassMethods)
        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable
          has_many :folders, :dependent => :destroy
        end

        super
      end

      module ClassMethods
      end

      module InstanceMethods
      end

    end
  end
end
