module Spree
  module VariantPresenterDecorator

    def initialize(opts = {})
      super(opts)
      @current_user = opts[:current_user]
    end

    def call
      @variants.map do |variant|
        {
          display_price: display_price(variant),
          price: variant.price_in(current_currency),
          display_compare_at_price: display_compare_at_price(variant),
          should_display_compare_at_price: should_display_compare_at_price?(variant),
          is_product_available_in_currency: @is_product_available_in_currency,
          backorderable: backorderable?(variant),
          in_stock: in_stock?(variant),
          images: images(variant),
          option_values: option_values(variant),
          stock_notify: stock_notify(variant)
        }.merge(
          variant_attributes(variant)
        )
      end
    end

    # User specific stock_notify corresponding to variants
    def stock_notify(variant)
      return [] unless @current_user
      @current_user.stock_notify.where(variant_id: variant.id, notified: false)
    end
  end
end

Spree::VariantPresenter.prepend(Spree::VariantPresenterDecorator)
