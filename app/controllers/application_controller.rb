class ApplicationController < ActionController::Base
  def after_sign_in_path_for(resource)
    case resource
    when Customer
      items_path(resource)
    when Admin
      admin_path
    when Exective
      exective_items_path(resource)
    end
  end
end
