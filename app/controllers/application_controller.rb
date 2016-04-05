class ApplicationController < ActionController::Base
  require 'offsite_payments/action_view_helper'

  ActionView::Base.send(:include, OffsitePayments::ActionViewHelper)

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end
