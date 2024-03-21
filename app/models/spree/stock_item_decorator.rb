module Spree
  module StockItemDecorator
    def self.prepended(base)
      base.after_update :check_stock_if_count_on_hand_changed_and_greater_than_zero
    end

    private

    def check_stock_if_count_on_hand_changed_and_greater_than_zero
      variant.mark_as_notified if count_on_hand > 0
    end
  end
end

Spree::StockItem.prepend(Spree::StockItemDecorator)
