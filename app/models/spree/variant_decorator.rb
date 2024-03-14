module Spree
  module VariantDecorator
    def self.prepended(base)
      base.has_many :stock_notify, class_name: 'Spree::StockNotify', dependent: :destroy
    end

    def mark_as_notified
      if !stock_notification && stock_notify.exists?(notified: false)
        self.stock_notification = true
        save
      end
    end
  end
end

Spree::Variant.prepend(Spree::VariantDecorator)
