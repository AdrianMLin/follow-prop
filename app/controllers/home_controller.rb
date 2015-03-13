
class HomeController < ApplicationController

  def index

    pop_full = HTTParty.get('https://api.instagram.com/v1/media/popular?access_token=23131423.223b0db.6f8d56ddbfce4128936ecf2e8e926dce')['data']
    
    pop_image_ids = []


    # get all popular posts

    # get ids of images

    # from  image ids get all likes

    # from likes get all users

    # paginate users, sort by ratio

    # send users to models

    binding.pry

    render(:index)
  end
end