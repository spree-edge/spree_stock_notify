class StockNotifyService
  def self.run
    notified_emails = Set.new

    Spree::Variant.includes(:stock_notify).where(stock_notification: true).each do |variant|
      variant.stock_notify.where(notified: false).each do |stock_notify|
        email = stock_notify.user&.email || stock_notify.email
        unless notified_emails.include?(email)
          notified_emails << email
          Spree::StockNotifyMailer.with(email: email, variant: variant).variant_back_in_stock_email.deliver_later
          mark_stock_notify_as_notified(email, variant)
        end
      end
      variant.stock_notification = false
      variant.save
    end
  end

  private

  def self.mark_stock_notify_as_notified(email, variant)
    Spree::StockNotify.where(email: email, variant_id: variant.id, notified: false).update(notified: true)
  end
end
