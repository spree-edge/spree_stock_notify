class StockNotifyMailer < ApplicationMailer
		
  def variant_back_in_stock
    @email = params[:email]
    @variant = params[:variant]
    mail(to: @email, subject: "Variant back in stock")
  end
  
end
