module Spree
  module StockItemDecorator
    def self.prepended(base)
      base.after_save { variant.check_stock }
    end
  end
end

Spree::StockItem.prepend(Spree::StockItemDecorator)
