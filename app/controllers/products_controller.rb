class ProductsController < ApplicationController
  def index
    @products = Product.all
    @product = Product.find(params[:id]) if params[:id]
  end
end
