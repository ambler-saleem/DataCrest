class Wholesaler < ApplicationRecord
  has_many :salespeople, dependent: :destroy
  has_many :agent_wholesalers
  has_many :agents, through: :agent_wholesalers

  mount_uploader :logo, LogoUploader

  belongs_to :owner, class_name: "Salesperson"

  validates :title, presence: true
end
