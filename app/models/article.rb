# == Schema Information
#
# Table name: articles
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer
#
class Article < ApplicationRecord
  belongs_to :user
  validates :title, presence: true, length: { minimum: 10, maximum: 100 }
  validates :description, presence: true, length: { minimum: 20, maximum: 255 }
end
