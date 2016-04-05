class PaymentController < ApplicationController
  def main
    # Rendered from views/payment/main.html.erb
  end

  def offsite
    # Rendering the offsite payment button handled in views/payment/offsite.html.erb with a helper
  end

  def return
    # Create now Notification class
    notify = OffsitePayments::Integrations::CheckoutFinland::Notification.new(params)
 
    # Verify MAC with the security key
    # Note: Correct MAC doesn't imply payment was transferred
    if notify.acknowledge("SAIPPUAKAUPPIAS")
      if notify.complete?
        @status = "Payment complete, status code: " + notify.status
      elsif notify.delayed?
        @status = "Payer chose delayed payment, status code: " + notify.status
      elsif notify.activation?
        @status = "Manual activation requeired, status code: " + notify.status
      elsif notify.cancelled?
        @status = "Payment cancelled, status code: " + notify.status
      end
    else
      @status = "MAC check failed"
    end
  end
end
