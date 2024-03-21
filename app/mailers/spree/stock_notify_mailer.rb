module Spree
  class StockNotifyMailer < BaseMailer		
    def variant_back_in_stock_email
      @email = params[:email]
      @variant = params[:variant]
      mail(to: @email, subject: "Variant back in stock")
    end
  end
end
