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
        Spree::StockNotifyMailer.with(email: email, variant: variant).variant_back_in_stock_email.deliver_later
        mark_stock_notify_as_notified(email, variant)
      end
    end
  end

  private

  def self.mark_stock_notify_as_notified(email, variant)
    Spree::StockNotify.where(email: email, variant_id: variant.id, notified: false).update(notified: true)
  end
end
