class Libauxdet < ActiveRecord::Base
  belongs_to :libauxdetable, polymorphic: true
end
