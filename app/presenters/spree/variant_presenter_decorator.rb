module Spree
	module VariantPresenterDecorator
    def initialize(opts = {})
      @variants = opts[:variants]
      @is_product_available_in_currency = opts[:is_product_available_in_currency]
      @current_currency = opts[:current_currency]
      @current_price_options = opts[:current_price_options]
      @current_store = opts[:current_store]
      @current_user = opts[:current_user]
    end

    def call
    	debugger
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

    def stock_notify(variant)
      @current_user.stock_notify.where(variant_id: variant.id)
    end
	end
end

Spree::VariantPresenter.prepend(Spree::VariantPresenterDecorator)