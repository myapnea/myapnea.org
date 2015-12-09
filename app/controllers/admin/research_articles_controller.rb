class Admin::ResearchArticlesController < ApplicationController
  before_action :authenticate_user!,          except: [:photo]
  before_action :check_owner,                 except: [:photo]
  before_action :set_admin_research_article,  only: [:show, :edit, :update, :destroy, :photo]

  layout 'admin'

  def photo
    if @admin_research_article.photo.size > 0
      send_file File.join(CarrierWave::Uploader::Base.root, @admin_research_article.photo.url)
    else
      head :ok
    end
  end

  def order
    @admin_research_articles = Admin::ResearchArticle.current.order(:position)
  end

  # GET /admin/research_articles
  # GET /admin/research_articles.json
  def index
    @admin_research_articles = Admin::ResearchArticle.current.order(:position)
  end

  # GET /admin/research_articles/1
  # GET /admin/research_articles/1.json
  def show
  end

  # GET /admin/research_articles/new
  def new
    @admin_research_article = Admin::ResearchArticle.new
  end

  # GET /admin/research_articles/1/edit
  def edit
  end

  # POST /admin/research_articles/1/preview
  def preview
    @admin_research_article = Admin::ResearchArticle.new(admin_research_article_params) unless @admin_research_article.present?
  end

  # POST /admin/research_articles
  # POST /admin/research_articles.json
  def create
    @admin_research_article = Admin::ResearchArticle.new(admin_research_article_params)

    respond_to do |format|
      if @admin_research_article.save
        format.html { redirect_to @admin_research_article, notice: 'Research article was successfully created.' }
        format.json { render :show, status: :created, location: @admin_research_article }
      else
        format.html { render :new }
        format.json { render json: @admin_research_article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/research_articles/1
  # PATCH/PUT /admin/research_articles/1.json
  def update
    respond_to do |format|
      if @admin_research_article.update(admin_research_article_params)
        format.html { redirect_to @admin_research_article, notice: 'Research article was successfully updated.' }
        format.json { render :show, status: :ok, location: @admin_research_article }
      else
        format.html { render :edit }
        format.json { render json: @admin_research_article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/research_articles/1
  # DELETE /admin/research_articles/1.json
  def destroy
    @admin_research_article.destroy
    respond_to do |format|
      format.html { redirect_to admin_research_articles_url, notice: 'Research article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_research_article
      @admin_research_article = Admin::ResearchArticle.find_by_param(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_research_article_params
      params.require(:admin_research_article).permit(:title, :slug, :description, :content, :position, :photo, :author, :credentials, :references)
    end
end
