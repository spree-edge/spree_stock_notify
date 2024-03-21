class StockNotifyJob < ApplicationJob
  queue_as :default

  def perform
    Apartment.tenant_names.each do |tenant|
      Apartment::Tenant.switch(tenant) do
        Spree::Store.all.each do |store|
          if Flipper.enabled?(:stock_notify, store.try(:id))
            StockNotifyService.run
          end
        end
      end
    end
  end
end
