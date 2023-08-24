class ApplicationController < ActionController::Base
  def after_sign_in_path_for(resource)
    case resource
    when Customer
      customer_path(resource)
    when Admin
      admin_path
    when Exective
      exective_root_path
    end
  end
end
