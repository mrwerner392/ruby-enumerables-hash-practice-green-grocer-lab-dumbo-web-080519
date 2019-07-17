# count and consolidate items in a shopping cart
def consolidate_cart(cart)
  cart_hash = cart.reduce({}) do |memo, item|
    item.reduce({}) do |memo2, (key, value)|
      if memo[key]
        memo[key][:count] += 1
      else
        memo[key] = value
        memo[key][:count] = 1
      end
    end
    memo
  end
end

# update cart to account for coupons
def apply_coupons(cart, coupons)
  coupons.each do |elem|
    if cart[elem[:item]]
      if cart["#{elem[:item]} W/COUPON"]
        cart["#{elem[:item]} W/COUPON"][:count] += elem[:num]
      else
        coupon_price = elem[:cost] / elem[:num]
        coupon_clearance = cart[elem[:item]][:clearance]
        cart["#{elem[:item]} W/COUPON"] = {
          price: coupon_price,
          clearance: coupon_clearance,
          count: elem[:num]
        }
      end
      cart[elem[:item]][:count] -= elem[:num]
    end
  end
  cart
end

# apply clearance discount where appropriate
def apply_clearance(cart)
  cart.reduce({}) do |memo, (key, value)|
    if value[:clearance]
      value[:price] = (value[:price] * 0.8).round(2)
      memo[key] = value
    end
    memo
  end
end

# calculate total cost of cart
def checkout(cart, coupons)
  #consolidated_cart = consolidate_cart(cart)
  #consolidated_cart_w_coupons = apply_coupons(consolidated_cart, coupons)
  final_cart = apply_clearance( apply_coupons( consolidate_cart(cart), coupons ) )
  total = final_cart.reduce(0) do |memo (key, value)|
    memo += (value[:price] * value[:count])
    memo
  end
  if total > 100
    total *= 0.9
  end
end
