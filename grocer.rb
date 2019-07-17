def consolidate_cart(cart)
  cart_hash = cart.reduce({}) do |memo, elem|
    current_key = ""
    elem.reduce({}) do |memo2, (key, value)|
      current_key = key
      value[:count] = 1
      memo2[key] = value
      memo2
    end

    if memo[current_key]
      memo[current_key][:count] += 1
    else
      memo << elem
    end
    memo
  end
end

=begin
def apply_coupons(cart, coupons)
  coupons.each do |elem|
    if cart[elem[:item]]
      if cart[elem[:item]][:count] >= elem[:num]
        new_name = "#{elem[:item]} W/COUPON"
        if cart[new_name]
          cart[new_name][:count] += elem[:num]
        else
          cart[new_name] = {
            price: elem[:cost] / elem[:num],
            clearance: cart[elem[:item]][:clearance],
            count: elem[:num]
          }
        end
        cart[elem[:item]][:count] -= elem[:num]
      end
    end
  end
  cart
end

=end

def apply_coupons(cart, coupons)
  coupons.each do |elem|
    if cart[elem[:item]]
      if cart["#{elem[:item]} W/COUPON"]
        cart["#{ele[:item]} W/COUPON"][:count] += elem[:num]
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


def apply_clearance(cart)
  cart.reduce({}) do |memo, (key, value)|
    if value[:clearance]
      value[:price] = (value[:price] * 0.8).round(2)
      memo[key] = value
    end
    memo
  end
end

def checkout(cart, coupons)
  # code here
end
