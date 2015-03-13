class HomeController < ApplicationController

  def index
    binding.pry
    render(:index)
  end
end