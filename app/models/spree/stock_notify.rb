class Spree::StockNotify < ApplicationRecord
	belongs_to :user
	belongs_to :variant

	validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, unless: :skip_email_validation?

	private

	def skip_email_validation?
	  email.blank? && !user.blank?
	end

end
