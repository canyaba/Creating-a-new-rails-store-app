require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bulk_category = Category.create!(name: "Garden")

    26.times do |index|
      Product.create!(
        title: format("Paged Product %02d", index),
        description: "Bulk product #{index}",
        price: index + 1,
        stock_quantity: 15,
        category: @bulk_category
      )
    end

    @category_match = Product.create!(
      title: "Garden Shovel",
      description: "Tools for the yard",
      price: 42.50,
      stock_quantity: 8,
      category: @bulk_category
    )

    @search_only_match = Product.create!(
      title: "Search Target Lamp",
      description: "Lighting",
      price: 15.25,
      stock_quantity: 3,
      category: categories(:one)
    )

    @expensive_product = Product.create!(
      title: "Premium Sofa",
      description: "High price product",
      price: 999.99,
      stock_quantity: 25,
      category: categories(:two)
    )
  end

  test "should get index" do
    get products_url

    assert_response :success
    assert_select "h1", "Products"
    assert_select ".product-card", 24
    assert_select ".pagination"
    assert_select "form.filters-form"
    assert_match "$9.99", response.body
    assert_match "Out of stock", response.body
  end

  test "should get show" do
    get product_url(products(:one))

    assert_response :success
    assert_select "h1", "Alpha Lamp"
    assert_match "$9.99", response.body
    assert_match "Back to products", response.body
    assert_match "Out of stock", response.body
    assert_match products(:one).description, response.body
  end

  test "index truncates descriptions" do
    get products_url

    assert_response :success
    assert_no_match products(:one).description, response.body
    assert_match "This product has a long description intended for the...", response.body
  end

  test "should paginate products" do
    get products_url(page: 2)

    assert_response :success
    assert_select ".product-card", Product.count - 24
    assert_match "Page <strong>2</strong> of", response.body
  end

  test "should filter by title search" do
    get products_url(q: "Search Target")

    assert_response :success
    assert_match "Search Target Lamp", response.body
    assert_no_match "Garden Shovel", response.body
  end

  test "should filter by category" do
    get products_url(category_id: @bulk_category.id)

    assert_response :success
    assert_match "Garden Shovel", response.body
    assert_no_match "Alpha Lamp", response.body
  end

  test "should combine search and category filters" do
    get products_url(q: "Garden", category_id: @bulk_category.id)

    assert_response :success
    assert_match "Garden Shovel", response.body
    assert_no_match "Search Target Lamp", response.body
  end

  test "should sort by descending price" do
    get products_url(sort: "price_desc")

    assert_response :success
    assert_operator response.body.index("Premium Sofa"), :<, response.body.index("Garden Shovel")
  end

  test "should fall back to title sort for invalid sort" do
    get products_url(sort: "not_valid")

    assert_response :success
    assert_operator response.body.index("Alpha Lamp"), :<, response.body.index("Beta Chair")
  end
end
