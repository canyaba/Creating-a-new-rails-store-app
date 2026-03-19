class Product < ApplicationRecord
  belongs_to :category

  validates :title, presence: true
  validates :price, presence: true
  validates :stock_quantity, presence: true

  def stock_status
    return "Out of stock" if stock_quantity.to_i.zero?
    return "Low stock" if stock_quantity.to_i <= 10

    "In stock"
  end
end
