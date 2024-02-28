class StockNotifyJob < ApplicationJob
  queue_as :default

  def perform
    StockNotifyService.run
  end
end
