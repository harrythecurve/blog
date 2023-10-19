class ArticlesController < ApplicationController
  before_action :set_article, only: %i[show edit update destroy]
  before_action :require_user, except: %i[index show]
  before_action :authorise_user, only: %i[edit update destroy]

  def index
    @articles = Article.paginate(page: params[:page], per_page: 9)
  end

  def show; end

  def new
    @article = Article.new
  end

  def create
    @article = current_user.articles.new(article_params)
    if @article.save
      flash[:notice] = "Article successfully created."
      redirect_to @article
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @article.update(article_params)
      flash[:notice] = "Article successfully edited."
      redirect_to @article
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    if @article.delete
      flash[:notice] = "Article successfully deleted."
    else
      flash[:notice] = "Article could not be deleted."
    end
    redirect_to articles_path
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :description)
  end

  def authorise_user
    unless current_user == @article.user || current_user&.admin?
      flash[:error] = "You can only edit or delete your own articles"
      redirect_to @article
    end
  end
end
