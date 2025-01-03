class Spree::StockNotify < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :variant, touch: true

  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, unless: :skip_email_validation?
  validates_uniqueness_of :email, scope: %i[variant_id notified], on: :create

  private

  def skip_email_validation?
    email.blank? && !user.blank?
  end
end
