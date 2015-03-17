
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

          num_followed_by = user['counts']["followed_by"]
          num_follows = user['counts']["follows"]

          num_followed_by = 0.01 if num_followed_by <= 0 #can't divide by zero
          user["following_to_follower_ratio"] = num_follows / num_followed_by.to_f #need to make it a fraction. integer / integer must return integer
        else
          user["counts"] = {media: 0, followed_by: 0, follows: 0}
          user['following_to_follower_ratio'] = 0
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

    render(:index, {locals: {commenters: commenters} } )
  end


end