class Crawlelist < ActiveRecord::Base
  belongs_to :group
  belongs_to :url
  belongs_to :user
end
