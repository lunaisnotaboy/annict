# == Schema Information
#
# Table name: profiles
#
#  id                   :integer          not null, primary key
#  user_id              :integer          not null
#  name                 :string(510)      default(""), not null
#  description          :string(510)      default(""), not null
#  avatar_uid           :string(510)
#  background_image_uid :string(510)
#  created_at           :datetime
#  updated_at           :datetime
#
# Indexes
#
#  profiles_user_id_idx  (user_id)
#  profiles_user_id_key  (user_id) UNIQUE
#

class Profile < ActiveRecord::Base
  dragonfly_accessor :avatar do
    default 'public/images/no_image.png'
  end
  dragonfly_accessor :background_image

  belongs_to :user

  validates :description, length: { maximum: 150 }
  validates :name, presence: true

  before_validation :rename_file


  def description=(description)
    value = description.present? ? description.truncate(150) : ''
    write_attribute(:description, value)
  end


  private

  def rename_file
    avatar.name = random_file_name(avatar) if avatar.present?
    background_image.name = random_file_name(background_image) if background_image.present?
  end

  def random_file_name(file)
    ext = file.name.scan(/\.[a-zA-Z]+$/).first.presence || ''
    SecureRandom.hex(16) + ext
  end
end
