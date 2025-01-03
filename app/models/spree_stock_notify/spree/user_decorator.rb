module SpreeStockNotify
  module Spree
    module UserDecorator
      def self.prepended(base)
        base.has_many :stock_notify, class_name: 'Spree::StockNotify', dependent: :destroy
      end
    end
  end
end

::Spree::User.prepend(SpreeStockNotify::Spree::UserDecorator)
