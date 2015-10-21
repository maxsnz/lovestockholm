class Player < ActiveRecord::Base
  # has_many :results

  validates :uid, presence: true, uniqueness: true
  validates_presence_of :name
end
