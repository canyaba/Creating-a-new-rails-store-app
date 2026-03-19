module ProductsHelper
  def products_query_params(overrides = {})
    request.query_parameters.merge(overrides).compact_blank
  end

  def stock_status_badge_class(product)
    case product.stock_status
    when "Out of stock"
      "status-badge status-badge--out"
    when "Low stock"
      "status-badge status-badge--low"
    else
      "status-badge status-badge--in"
    end
  end
end
