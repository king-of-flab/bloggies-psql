class PostsController < ApplicationController
  before_action :authenticate_user!, # except: [:index] this authenticates everything except index

  def index
    # render json: current_user.posts
    news_url = 'https://newsapi.org/v1/articles?source=talksport&sortBy=top&apiKey=5cfef96295754722970178955f8adcfd'
    response = HTTParty.get(news_url)
    # render json: response

    @news_data = response
    @all_posts = current_user.posts
    @new_post = current_user.posts.new
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    render html: 'show form to create new post'
  end

  def edit
    @edited_post = Post.find(params[:id])
  end

  def update
    edited_post = Post.find(params[:id])

    edited_post.update(params.require(:post).permit(:title, :content))
    redirect_to posts_path if edited_post.save
  end

  def create
    creating_post = params.require(:post).permit(:title, :content, :user_id)
    # creating_post = current_user.post.build() - alternative method
    # render json: @creating_post

    # creating_post.title = params[:post][:title] - alternative method continued
    Post.create(creating_post)

    redirect_to posts_path
  end

  def destroy
    Post.destroy(params[:id])

    redirect_to posts_path
  end

  def foo
  end
end
