class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]


  def home

  end
  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all.paginate(:page => params[:page], :per_page => 100)
    @posts = @posts.where("price > ?", params["min_price"]) if params["min_price"].present?
    @posts = @posts.where("price < ?", params["max_price"]) if params["min_price"].present?
    @posts = @posts.where(city: params["city"]) if params["city"].present?
    @posts = @posts.where(address: params["address"]) if params["address"].present?
    @posts = @posts.where(source_account: params["source_account"]) if params["source_account"].present?

  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @images = @post.images
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
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
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
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
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
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
      params.require(:post).permit(:heading, :body, :price, :city, :external_url, :timestamp)
    end
end
