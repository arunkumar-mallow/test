class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]

  # GET /posts or /posts.json
  def index
    @rating = Rating.all.order("average DESC")
    @rating_asc = Rating.all.order("average ASC")
  end

  # GET /posts/1 or /posts/1.json
  def show
    @rating = @post.rating
  end

  def ratings
    puts "===============Working====================="

    rating = Rating.find_by(post_id: params[:post_id])

    star = params[:rating]
    if star == "1"
      rating.update(s1: rating[:s1].to_i + 1)
    elsif star == "2"
      rating.update(s2: rating[:s2].to_i + 1)
    elsif star == "3"
      rating.update(s3: rating[:s3].to_i + 1)
    elsif star == "4"
      rating.update(s4: rating[:s4].to_i + 1)
    elsif star == "5"
      rating.update(s5: rating[:s5].to_i + 1)
    end

    total = rating[:s5].to_i * 5 + rating[:s4].to_i * 4 + rating[:s3].to_i * 3 + rating[:s2].to_i * 2 + rating[:s1].to_i
    total_star = rating[:s1].to_i + rating[:s2].to_i + rating[:s3].to_i + rating[:s4].to_i + rating[:s5].to_i

    average = total.to_f / total_star.to_f
    puts "Average"
    puts average.round(2)

    rating.update(average: average.round(2))

    respond_to do |format|
      format.html { redirect_to post_url(params[:post_id]), notice: "Rating Updated" }
    end
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)

   

    respond_to do |format|
      if @post.save

        puts "new post"
        puts @post.id

        Rating.new(s1: 0, s2: 0, s3: 0, s4: 0, s5: 0, average: 0, post_id: @post.id).save
        format.html { redirect_to post_url(@post), notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to post_url(@post), notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.require(:post).permit(:content)
  end
end
