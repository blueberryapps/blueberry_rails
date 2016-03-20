module Admin
  class BaseController < ApplicationController
    before_action :authenticate_administrator!
    layout 'admin'
  end
end
