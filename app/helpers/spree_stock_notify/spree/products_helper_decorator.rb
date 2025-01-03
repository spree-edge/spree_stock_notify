module SpreeStockNotify
  module Spree
    module ProductsHelperDecorator
      def check_current_user_notify(spree_current_user)
        # For variants, display of notify form will be handled in cart_form.js
        return true unless @product.variants.empty?

        master_product = @product.master

        # Show notify form if guest user
        return true if spree_current_user.nil? && !master_product.in_stock?

        user_specific_stock_notify = master_product.stock_notify.where(user_id: spree_current_user&.id, notified: false)
        !(user_specific_stock_notify.any? || master_product.in_stock?)
      end

      def product_variants_matrix(is_product_available_in_currency)
        ::Spree::VariantPresenter.new(
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
end

::Spree::ProductsHelper.prepend(::SpreeStockNotify::Spree::ProductsHelperDecorator)
