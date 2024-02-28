class Spree::StockNotify < ApplicationRecord
	belongs_to :user
	belongs_to :variant
end
