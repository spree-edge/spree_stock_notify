class StockNotifyService
  def self.run
    notified_emails = Set.new

    Spree::Variant.includes(:stock_notify).where(stock_notification: true).each do |variant|
      variant.stock_notify.where(notified: false).each do |stock_notify|
        email = stock_notify.user&.email || stock_notify.email
        notified_emails << email unless notified_emails.include?(email)
      end
      
      variant.stock_notification = false
      variant.save
    end

    notified_emails.each do |email|
      stock_notify_ids = Spree::StockNotify.where(email: email, notified: false).pluck(:variant_id)
      variants = Spree::Variant.where(id: stock_notify_ids)
      variants.each do |variant|
        StockNotifyMailer.with(email: email, variant: variant).variant_back_in_stock.deliver_later
      end
      mark_stock_notify_as_notified(email, variants)
    end
  end

  private

  def self.mark_stock_notify_as_notified(email, variants)
    Spree::StockNotify.where(email: email, variant_id: variants.pluck(:id), notified: false)
                      .update_all(notified: true)
  end
end
