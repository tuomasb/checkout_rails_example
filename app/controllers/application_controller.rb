class ApplicationController < ActionController::Base
  require 'active_merchant/billing/integrations/action_view_helper'

  ActionView::Base.send(:include, ActiveMerchant::Billing::Integrations::ActionViewHelper)

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end
