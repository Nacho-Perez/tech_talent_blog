class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]

  skip_before_action :authenticate_user!, only: [:index, :show]

  # GET /posts
  # GET /posts.json
  def user_posts
    @user = User.find_by(username: params[:name])
    @posts_by_user = @user.posts.page(params[:page])
  end

  def index
    @category = params[:category]
    if @category.blank?
      @posts = Post.all.order(updated_at: :desc).page(params[:page])
    else
      @posts = Post.where(category: @category).order(updated_at: :desc).page(params[:page])
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @comment = Comment.new
    @category = @post.category
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
    @category = @post.category  
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'El post fue creado con éxito.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'El post fue actualizado correctamente.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'El post fue eliminado con éxito.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :author, :input_blog, :category, :user_id, :picture)
    end

    #Avoid an user can edit and destroy posts from another users
    def correct_user
      @post = Post.find_by(id: params[:id])
      unless current_user.id == @post.user_id
        redirect_to @post
      end
    end
end
