module Spree
  module StockItemDecorator
    def self.prepended(base)
      base.after_update :notify_users_based_on_stock_increase
    end

    private

    def notify_users_based_on_stock_increase
      return unless saved_change_to_count_on_hand? && count_on_hand > 0

      return if variant.stock_notify.where(notified: false).empty?

      notify_users_in_batches(count_on_hand)
    end

    def notify_users_in_batches(count_on_hand)
      notified_emails = Set.new

      variant.stock_notify.where(notified: false).order(:created_at).limit(count_on_hand).each do |stock_notify|
        email = stock_notify.user&.email || stock_notify.email
        next if notified_emails.include?(email)

        Spree::StockNotifyMailer.with(email: email, variant: variant).variant_back_in_stock_email.deliver_later

        mark_stock_notify_as_notified(email)
        notified_emails << email
      end
    end

    def mark_stock_notify_as_notified(email)
      variant.stock_notify.where(email: email, notified: false).update(notified: true)
     end
  end
end

Spree::StockItem.prepend(Spree::StockItemDecorator)
