class TopicsController < ApplicationController
  before_action :set_topic, only: [:show, :edit, :update, :destroy]

  # GET /topics
  # GET /topics.json
  def index
    @topics = Topic.all
  end

  # GET /topics/1
  # GET /topics/1.json
  def show
    @posts = @topic.posts.order(created_at: :asc).preload(:user)

    base_words = ["ing", "the", "of", "to", "and", "a", "in", "is", "it", "you", "that", "was", "for", "on", "are", "with", "as", "I", "n", "ed", "s"]
    @words = (JSON.load(@topic.words) + base_words).map{|x| x.strip}.sort.uniq
    puts @words.inspect
  end

  # GET /topics/new
  def new
    @topic = Topic.new
  end

  # GET /topics/1/edit
  def edit
  end

  # POST /topics
  # POST /topics.json
  def create
    @topic = Topic.new(topic_params)
    words = @topic.words.split("\n").map {|x| x.strip}
    if (words.size < 10)
      flash[:alert] = "You need at least 10 words to create a poem topic"
      render :new
      return
    end
    if (words.size > 40)
      flash[:alert] = "You can use at most 40 words. Right now you have #{words.size}"
      render :new
      return
    end

    @topic.words = JSON.dump(words)

    respond_to do |format|
      if @topic.save
        format.html { redirect_to @topic, notice: 'Topic was successfully created.' }
        format.json { render :show, status: :created, location: @topic }
      else
        format.html { render :new }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /topics/1
  # PATCH/PUT /topics/1.json
  def update
    respond_to do |format|
      if @topic.update(topic_params)
        format.html { redirect_to @topic, notice: 'Topic was successfully updated.' }
        format.json { render :show, status: :ok, location: @topic }
      else
        format.html { render :edit }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /topics/1
  # DELETE /topics/1.json
  def destroy
    if current_user.username != 'julia'
      format.html { redirect_to '/', notice: "You don't have permission to do that" }
    end
    @topic.posts.destroy_all
    @topic.destroy
    respond_to do |format|
      format.html { redirect_to '/', notice: 'Topic was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_topic
      @topic = Topic.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def topic_params
      params.require(:topic).permit(:title, :words)
    end
end
