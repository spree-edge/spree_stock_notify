module Spree
  module Api
    module V2
      module Storefront
        module ProductsControllerDecorator

          def self.prepended(base)
            base.before_action :check_user_stock_notification, only: [:stock_notify]
          end

          def stock_notify
          	debugger
            @stock_notify = Spree::StockNotify.new(stock_notify_params.merge(user_id: spree_current_user.try(:id)))
            @product = Spree::Variant.find_by(id: stock_notify_params[:variant_id]).product
            @product_by_variant = product_path(@product, variant_id: stock_notify_params[:variant_id])
            if @stock_notify.save
            	render json: @stock_notify, each_serializer: Spree::V2::Storefront::StockNotifySerializer
  					end
          end

          private

          def stock_notify_params
            params.require(:stock_notify).permit(:variant_id, :email, :user_id)
          end

          def check_user_stock_notification
          	unless spree_current_user
	            stock_notify = Spree::StockNotify.find_by(stock_notify_params.merge(notified: false))
	            if stock_notify.present?
	            	# render json: stock_notify, each_serializer: Spree::Api::V2::Storefront::StockNotifySerializer
	              # render turbo_stream: turbo_stream.replace('notification_frame', partial: 'spree/shared/alert')
	            end
	          end
          end
        end
      end
    end
  end
end

Spree::Api::V2::Storefront::ProductsController.prepend(::Spree::Api::V2::Storefront::ProductsControllerDecorator)

