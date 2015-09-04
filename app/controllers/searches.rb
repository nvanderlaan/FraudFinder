get "/searches" do
  @search = Search.find(current_user.searches.last.id)
  erb :"searches/show"
end

post "/searches" do
  @search = Search.new(source_img_url: params[:source_img_url])
  current_user.searches << @search

  if @search.save
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
