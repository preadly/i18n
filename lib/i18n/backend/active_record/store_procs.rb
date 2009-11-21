# This module is intended to be mixed into the ActiveRecord backend to allow
# storing Ruby Procs as translation values in the database.
#
#   I18n.backend = I18n::Backend::ActiveRecord.new
#   I18n::Backend::ActiveRecord::Translation.send(:include, I18n::Backend::ActiveRecord::StoreProcs)
#
# The StoreProcs module requires the ParseTree and ruby2ruby gems and therefor
# was extracted from the original backend.
#
# ParseTree is not compatible with Ruby 1.9.
module I18n
  module Backend
    class ActiveRecord
      module StoreProcs
        unless RUBY_VERSION >= '1.9'
          class << self
            def included(target)
              require 'ruby2ruby'
              require 'parse_tree'
              require 'parse_tree_extensions'
            end
          end

          def value=(v)
            case v
              when Proc
                write_attribute(:value, v.to_ruby)
                write_attribute(:is_proc, true)
              else
                write_attribute(:value, v)
            end
          end
        end
      end
    end
  end
end
