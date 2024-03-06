module Spree
  class StockNotifiesController < Spree::StoreController
    before_action :check_user_stock_notification, only: [:create]
    def create
      @stock_notify = Spree::StockNotify.new(stock_notify_params.merge(user_id: spree_current_user.try(:id)))
      @product = Spree::Variant.find_by(id: stock_notify_params[:variant_id]).product

      @product_by_variant = product_path(@product, variant_id: stock_notify_params[:variant_id])
      if @stock_notify.save
        respond_to do |format|
          format.turbo_stream { render turbo_stream: turbo_stream.replace('notification_frame', partial: 'spree/shared/notification') }
        end
      else
        redirect_to @product_by_variant, status: :unprocessable_entity
      end
    end

    private

    def stock_notify_params
      params.permit(:variant_id, :email)
    end

    def check_user_stock_notification
      stock_notify = Spree::StockNotify.find_by(stock_notify_params.merge(notified: false))
      if stock_notify.present?
        render turbo_stream: turbo_stream.replace('notification_frame', partial: 'spree/shared/alert')
      end
    end
  end
end
