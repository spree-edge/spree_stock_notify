module Spree
  class StockNotifiesController < Spree::StoreController
    def create
      @stock_notify = Spree::StockNotify.new(stock_notify_params.merge(user_id: spree_current_user.try(:id)))
      @product = Spree::Variant.find_by(id: stock_notify_params[:variant_id]).product

      @product_by_variant = product_path(@product, variant_id: stock_notify_params[:variant_id])
      if @stock_notify.save
        respond_to do |format|
          format.turbo_stream { redirect_to @product_by_variant, notice: 'We will notify you when the product will be available.' }
          format.html
        end
      else
        redirect_to @product_by_variant, notice: 'Something went wrong'
      end
    end

    private

    def stock_notify_params
      params.permit(:variant_id, :email)
    end
  end
end
