class CategoriesController < ApplicationController
  before_action :load_category, only: %i[show]
  before_action only: %i[new create] do
    require_admin(categories_path)
  end

  def index
    @categories = Category.paginate(page: params[:page], per_page: 9)
  end

  def show
    @articles = @category.articles.paginate(page: params[:page], per_page: 9)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:alert] = "Category created"
      redirect_to @category
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def load_category
    @category = Category.find(params[:id])
  end
end
