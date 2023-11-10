class HomeController < ApplicationController
  def index
    @inns = Inn.all
  end
end