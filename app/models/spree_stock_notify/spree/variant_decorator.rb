module SpreeStockNotify
  module Spree
    module VariantDecorator
      def self.prepended(base)
        base.has_many :stock_notify, class_name: 'Spree::StockNotify', dependent: :destroy
      end
    end
  end
end

::Spree::Variant.prepend(SpreeStockNotify::Spree::VariantDecorator)
