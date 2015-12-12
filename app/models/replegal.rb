class Replegal < ActiveRecord::Base
  belongs_to :replegalable, polymorphic: true
  belongs_to :persona
end
