module Spree
  module Api
    module V2
      module Storefront
        module ProductsControllerDecorator
          def stock_notify
            @stock_notify = Spree::StockNotify.new(stock_notify_params)
            if @stock_notify.save
              render json: @stock_notify, each_serializer: Spree::V2::Storefront::StockNotifySerializer
            else
              render json: { errors: @stock_notify.errors.full_messages }, status: :unprocessable_entity
            end
          end

          private
          def stock_notify_params
            params.require(:stock_notify).permit(:variant_id, :email, :user_id)
          end
        end
      end
    end
  end
end

Spree::Api::V2::Storefront::ProductsController.prepend(::Spree::Api::V2::Storefront::ProductsControllerDecorator)

