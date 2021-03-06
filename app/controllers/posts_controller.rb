class PostsController < ApplicationController
  before_action:set_post, only:[:edit, :update, :destroy]
  before_action :authenticate_user!

  def index
    @posts = Post.all
  end

  def new
    if params[:back]
      @post = Post.new(posts_params)
    else
      @post = Post.new
    end
  end

  def create
    @post = Post.new(posts_params)
    @post.user_id = current_user.id
    if params[:cache][:picture] != ""
      @post.picture.retrieve_from_cache! params[:cache][:picture]
    end
    if @post.save
      redirect_to posts_path, notice: "投稿しました"
      NoticeMailer.sendmail_post(@post).deliver
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    @post.update(posts_params)
    redirect_to posts_path, notice: "編集しました"
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: "削除しました"
  end

  def confirm
    @post = Post.new(posts_params)
    if @post.invalid?
      render 'new'
    end
  end

  private
  def posts_params
    params.require(:post).permit(:content, :picture, :cache)
  end

  def set_post
    @post = Post.find(params[:id])
  end

end
