class ProductsController < ApplicationController
  PER_PAGE = 24

  def index
    @categories = Category.order(:name)
    @current_sort = allowed_sort
    @page = normalized_page

    scope = Product.includes(:category)
    scope = scope.where("products.title LIKE ?", "%#{ActiveRecord::Base.sanitize_sql_like(params[:q].to_s.strip)}%") if params[:q].present?
    scope = scope.where(category_id: params[:category_id]) if params[:category_id].present?
    scope = apply_sort(scope, @current_sort)

    total_count = scope.count
    @total_pages = [(total_count.to_f / PER_PAGE).ceil, 1].max
    @page = @total_pages if total_count.positive? && @page > @total_pages

    @products = scope.offset((@page - 1) * PER_PAGE).limit(PER_PAGE)
  end

  def show
    @product = Product.includes(:category).find(params[:id])
  end

  private

  def normalized_page
    page = params[:page].to_i
    page.positive? ? page : 1
  end

  def allowed_sort
    sort = params[:sort].presence
    %w[title_asc price_asc price_desc category_asc].include?(sort) ? sort : "title_asc"
  end

  def apply_sort(scope, sort)
    case sort
    when "price_asc"
      scope.order(price: :asc, title: :asc)
    when "price_desc"
      scope.order(price: :desc, title: :asc)
    when "category_asc"
      scope.left_joins(:category).order(Arel.sql("categories.name ASC, products.title ASC"))
    else
      scope.order(title: :asc)
    end
  end
end
