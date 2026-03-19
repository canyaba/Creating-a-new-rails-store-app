require "test_helper"

class ProductTest < ActiveSupport::TestCase
  test "stock_status returns out of stock when quantity is zero" do
    assert_equal "Out of stock", products(:one).stock_status
  end

  test "stock_status returns low stock when quantity is between one and ten" do
    assert_equal "Low stock", products(:two).stock_status
  end

  test "stock_status returns in stock when quantity is above ten" do
    product = Product.new(title: "Gamma Desk", description: "Desk", price: 29.99, stock_quantity: 11, category: categories(:one))

    assert_equal "In stock", product.stock_status
  end
end
