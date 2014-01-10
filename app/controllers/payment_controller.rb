class PaymentController < ApplicationController
  def main
    # Rendered from views/payment/main.html.erb
  end

  def offsite
    # Rendering the offsite payment button handled in views/payment/offsite.html.erb with a helper
  end

  def onsite
    # Onsite payment method fetches the POST URL's and parameters from checkout for each different
    # payment method supported by Checkout

    # Unique identifier for the payment, alphanumeric 20 characters max
    # Generate your own and store in database with the order, this demo app generates one and then discards it
    orderid = Time.now.to_i.to_s

    # New helper class for 2.00 EUR payment using Checkout test credentials
    # Merchant ID:375917 and security key "SAIPPUAKAUPPIAS" 
    service = ActiveMerchant::Billing::Integrations::CheckoutFinland::Helper.new(
    orderid, "375917", { :amount => "200", :currency => "EUR", :credential2 => "SAIPPUAKAUPPIAS" })

    # Reference number, language and other order details
    service.reference = "474738238"
    service.language = "FI"
    service.content = "1"
    service.delivery_date = "20140110"
    service.description = "Joku Tilaus"

    # Customer details
    service.customer :first_name => "Tero",
      :last_name => "Testaaja",
      :phone => "0800 552 010",
      :email => "support@checkout.fi"

    # Billing address
    service.billing_address :address1 => "Testikatu 1 A 10",
      :city => "Helsinki",
      :zip => "00100",
      :country => "FIN"

    # Return URLs for notification, cancellation etc.
    service.notify_url = "http://www.example.com"
    service.reject_url = "http://www.example.com"
    service.return_url = "http://www.example.com"
    service.cancel_return_url = "http://www.example.com"

    # Fetch XML response as Hash and make it available to views/payment/onsite.html.erb
    @data = service.get_onsite_buttons
  end

  def return
    # Create now Notification class
    notify = ActiveMerchant::Billing::Integrations::CheckoutFinland::Notification.new(params)
 
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
