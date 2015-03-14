
class HomeController < ApplicationController

  def index

    pop = HTTParty.get('https://api.instagram.com/v1/media/popular?access_token=23131423.223b0db.6f8d56ddbfce4128936ecf2e8e926dce')['data']
    
    pop_image_ids = []


    commenters = []
    likers = []

    pop.each do |item|
      pop_image_ids << item["id"] # get ids of images



      item['comments']['data'].each do |commenter| # get all commenters
        user = commenter['from'] # get user
        user_data = HTTParty.get("https://api.instagram.com/v1/users/#{ user['id'] }/?access_token=23131423.223b0db.6f8d56ddbfce4128936ecf2e8e926dce")

        if user_data["data"] #if not throttled
          counts = user_data["data"]["counts"] #get relevant data
          user["counts"] = counts #input relevant data into user hash
        end 

        commenters << user
      end
     
      
      # item['likes']['data'].each do |liker| # get all likers
      #   user = liker["from"]

      #   user_id = user['id'] # get user_id to make api call for user
      #   user_data = HTTParty.get("https://api.instagram.com/v1/users/#{ user['id'] }/?access_token=23131423.223b0db.6f8d56ddbfce4128936ecf2e8e926dce")

      #   if user_data["data"]
      #     counts = user_data["data"]["counts"] #get relevant data
      #     user["counts"] = counts #input relevant data into user hash
      #   end

      #   likers << user
      # end
      
    end

    binding.pry


    # now check follower count


    render(:index)
  end
end