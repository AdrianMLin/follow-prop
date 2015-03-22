
class HomeController < ApplicationController

  def index
    pop = HTTParty.get('https://api.instagram.com/v1/media/popular?access_token=23131423.223b0db.6f8d56ddbfce4128936ecf2e8e926dce')['data']

    # pop_image_ids = []


    commenters = []
    # likers = []

    pop.each do |item|
      # pop_image_ids << item["id"] # get ids of images f

      item['comments']['data'].each do |commenter| # get all commenters

        user = commenter['from'] # get user
        user_data = HTTParty.get("https://api.instagram.com/v1/users/#{ user['id'] }/?access_token=23131423.223b0db.6f8d56ddbfce4128936ecf2e8e926dce")

        if user_data["data"] #if not throttled
          counts = user_data["data"]["counts"] #get relevant data
          user["counts"] = counts #input relevant data into user hash

          num_followed_by = user['counts']["followed_by"]
          num_follows = user['counts']["follows"]

          num_followed_by = 0.01 if num_follows <= 0 #can't divide by zero
          user["followed_by_to_follows_ratio"] = num_followed_by / num_follows.to_f #need to make it a fraction. integer / integer must return integer
        else
          user["counts"] = {media: 0, followed_by: 0, follows: 0}
          user['followed_by_to_follows_ratio'] = 0
        end 

        commenters << user unless user['followed_by_to_follows_ratio'] == 0
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



    commenters.sort_by { |hash| hash["followed_by_to_follows_ratio"] } #sort by ratio

    binding.pry

    render(:index, {locals: {commenters: commenters} } )
  end


end