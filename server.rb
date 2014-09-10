require 'sinatra'
require 'active_record'
require 'twilio-ruby' 
require 'json'
require 'httparty'
require 'pry'
require_relative './lib/author'
require_relative './lib/connection'
require_relative './lib/micro_post'
require_relative './lib/snippet'
require_relative './lib/subscriber'
require_relative './lib/tag'

after do
	ActiveRecord::Base.connection.close
end

get('/') do
	erb(:index, { locals: { authors: Author.all() }})
end

get('/feed') do
	# Micro_post.create(post)
	erb(:feed, { locals: { posts: Micro_post.all().reverse, authors: Author.all()}})
end

post('/feed') do
	author = Author.find_by({name: params["author"]})
	image = HTTParty.get("https://api.instagram.com/v1/tags/#{params["tag"]}/media/recent?client_id=4c08eb6f8fb948d581437e9315b48fb2")["data"].sample["images"]["standard_resolution"]["url"]
	post = {"author_id" => author.id, "title" => params["title"], "content" => params["content"], "tag_name" => params["tag"], "created_at" => Time.new, "image" => image}
	tag = {"name" => params["tag"]}

	Micro_post.create(post)
	Tag.create(tag)

# 	account_sid = 'ACdd4bf15707f47abf0705c8118500a1a9' 
# 	auth_token = '29bcbf64f51836b99b54487bd1f6224c'
# 	@client = Twilio::REST::Client.new account_sid, auth_token

# # Twilio only works to my number since it is required to resister.
# 	Subscriber.all().each do |subscriber|
# 		@client.account.messages.create({
# 		:from => '+16467624182', 
# 		:to => subscriber.phone_number, 
# 		:body => "#{post["title"]} has been posted by #{Author.find_by({id: post["author_id"]})["name"]}",  
# 		})
# 	end

	# erb(:feed, { locals: { posts: Micro_post.all().reverse, authors: Author.all(), image: image }})
	redirect "/feed"
end

post('/feed/:add_author/add_author') do
	author = {"name" => request.env["rack.request.form_hash"]["add_author"]}
	author = Author.create(author)

	redirect "/feed"
end

put('/post/:id') do
	post = Micro_post.find_by(id: params[:id])
	author = Author.find_by(id: post.author_id)
	post_hush = {"content" => params["content"]}
	post.update(post_hush)

	erb(:feed, { locals: { posts: Micro_post.all(), authors: Author.all() }})
end

delete('/post/:id/delete') do
	post = Micro_post.find_by(id: params[:id])
	post.destroy

	redirect "/feed"
end

get('/authors/:id/posts') do
	posts = Micro_post.where(author_id: params[:id])

	erb(:"author/index", { locals: { posts: posts }})
end

get('/tag/posts') do
	tag = params["name"].delete('#')
	posts = Micro_post.where(tag_name: tag)
	erb(:"tag/tags", { locals: { posts: posts, tag: tag }})
end

get('/tag/:name/posts') do
	posts = Micro_post.where(tag_name: params[:name])
	erb(:"tag/index", { locals: { posts: posts }})
end

get('/posts/:id') do
	post = Micro_post.where(id: params[:id])[0]
	# response = HTTParty.get("https://api.instagram.com/v1/tags/#{post["tag-name"]}/media/recent?client_id=4c08eb6f8fb948d581437e9315b48fb2")
	# 	binding.pry
	# instagram = response["data"][0]["images"]["standard_resolution"]["url"]
	erb(:"post/post", { locals: { post: post }})
end

get('/authors') do
	erb(:"author/authors", { locals: { authors: Author.all() }})
end

get('/post/:id/edit') do
	post = Micro_post.find_by(id: params[:id])
	erb(:edit, { locals: { post: post}})
end

get('/subscribe') do
	erb(:"subscribe/index")
end

post('/subscribe/submit') do
	subscriber = {"name" => params["name"], "phone_number" => params["number"]}
	Subscriber.create(subscriber)

	erb(:"subscribe/submitted")
end

get('/reblog/:id') do
	post = Micro_post.find_by(id: params["id"])
	erb(:reblog, { locals: { content: post.content, author: Author.find_by(id: post.author_id), authors: Author.all() }})
end
