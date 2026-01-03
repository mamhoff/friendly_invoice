class Template < ActiveRecord::Base
  validates :name, presence: true
  validates :template, presence: true

  def to_s
    name
  end
end
