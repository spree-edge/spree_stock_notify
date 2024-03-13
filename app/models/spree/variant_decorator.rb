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




# module Spree
#   module VariantDecorator
#     def self.prepended(base)
#       base.has_many :stock_notify, class_name: 'Spree::StockNotify', dependent: :destroy
#       base.after_save :notify_customers_if_back_in_stock
#     end

#     def notify_customers_if_back_in_stock
#       debugger
#       return unless back_in_stock? && stock_notify.exists?

#       self.stock_notification = true
#     end

#     private

#     def back_in_stock?
#       debugger
#       can_supply? && total_on_hand.positive?
#     end
#   end
# end

# Spree::Variant.prepend(Spree::VariantDecorator)

