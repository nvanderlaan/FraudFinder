require_relative "../models/nethttp"
require_relative "../models/match"

get "/searches" do
  @search = Search.find(current_user.searches.last.id)
  erb :"searches/show"
end

post "/searches" do
  @search = Search.new(source_img_url: params[:source_img_url])
  current_user.searches << @search

  if @search.save
    result_hash = second_request_and_response(@search.source_img_url)
    p result_hash
      if result_hash["status"]
        p "Server currently busy"
      else
      final_hash = Match.process_matches(result_hash)
      p final_hash
      @search.matches.create!(img_host_url: final_hash.keys[0], img_direct_url: final_hash.values[0])
      @search.matches.create!(img_host_url: final_hash.keys[1], img_direct_url: final_hash.values[1])
      @search.matches.create!(img_host_url: final_hash.keys[2], img_direct_url: final_hash.values[2])
      @search.matches.create!(img_host_url: final_hash.keys[3], img_direct_url: final_hash.values[3])
      @search.matches.create!(img_host_url: final_hash.keys[4], img_direct_url: final_hash.values[4])
    end
    erb :"searches/show"
  else
    redirect "/"
  end
end

put "/searches/:id/edit" do
  @search = Search.find(params[:id])
  @search.update_attributes(params[:search])

  redirect "/searches"
end

get "/searches/:id/edit" do
  @search = Search.find(params[:id])
  @search.title = nil
  @search.description = nil

  # redirect "/searches"
  erb :"searches/edit", locals: { search: @search }
end
