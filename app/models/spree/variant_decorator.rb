module Spree
  module VariantDecorator
    def self.prepended(base)
      base.has_many :stock_notify, class_name: 'Spree::StockNotify', dependent: :destroy
    end

    def check_stock
      if can_supply? && total_on_hand > 0
        if !stock_notification && stock_notify.where(notified: false).exists?
          self.stock_notification = true
          save
        end
      end
    end
  end
end

Spree::Variant.prepend(Spree::VariantDecorator)
