class StockNotifyMailer < ApplicationMailer
		
  def variant_back_in_stock
    @email = params[:email]
    @variants = params[:variant]
    mail(to: @email, subject: "Variant back in stock")
  end
  
end
