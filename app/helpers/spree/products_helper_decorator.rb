module Spree
  module ProductsHelperDecorator
		def check_current_user_notify(spree_current_user)
		  debugger
		  return true unless @product.variants.empty?
		  master_product = @product.master
		  user_specific_stock_notify = master_product.stock_notify.where(user_id: spree_current_user.id, notified: false)
		 	if user_specific_stock_notify.any? || master_product.in_stock?
	 		 return false 
	 		else
	 			return true
	 		end
		end

		def product_variants_matrix(is_product_available_in_currency)
      Spree::VariantPresenter.new(
        variants: @variants,
        is_product_available_in_currency: is_product_available_in_currency,
        current_currency: current_currency,
        current_price_options: current_price_options,
        current_store: current_store,
        current_user: spree_current_user
      ).call.to_json
    end
  end
end

Spree::ProductsHelper.prepend(Spree::ProductsHelperDecorator)
