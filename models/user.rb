class User < ActiveRecord::Base
  has_many :crawlelists
end
