class Url < ActiveRecord::Base
  has_many :crawlelists
  has_many :recommends
end
