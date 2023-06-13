class Discount < ApplicationRecord
  def self.find_best_discount(customer_order_item)
    discounted_items = []; 
    discounted_best_price = [];
    like_query_params = []
    all_possible_combinations = []
    #customer_order_item = [4,5,7]

    (1..(customer_order_item.count)).each { |r| all_possible_combinations << customer_order_item.combination(r).to_a; }
    all_possible_combinations.flatten(1).each { |r| like_query_params << r.join(",") }

    discounted_items = Discount.where(item_ids: like_query_params)
    discounted_items.each { |d| 
        s = [];
        item_ids = d.item_ids.split(",")
        items = Item.where(id: item_ids); 
        items.each {|r| 
          s << {r.id => discounted_price(r.price, d.discount)}
        }
        discount_total = total_discount(s)
        # [{discount_id: [item_ids, total_discount]}]
        discounted_best_price << Hash[d.id,[d.item_ids, discount_total]]
    }


    best_discounted_total = []

    discounted_best_price.each { |r|
      discount_id = r.keys[0]
      discounted_item_id_array = r.values.first[0].split(",")
      non_discounted_item_ids = customer_order_item - discounted_item_id_array.map(&:to_i)
      non_discounted_item_total = Item.where(id: non_discounted_item_ids).pluck(:price).sum
      discounted_item_total = non_discounted_item_total + r.values.first[1]
      best_discounted_total << Hash[discount_id, discounted_item_total]
    }

    # Find the best discount id, which has min value
    best_discount = best_discounted_total.min_by { |hash| hash.values.first }.keys.first

    discount = Discount.find(best_discount)



    # irb(main):486:0> best_discounted_total
    # => [{4=>270.0}, {5=>255.0}]

    # best price of different combination

    # [4,5,6,7] - [4,5] => [6,7]
    # [4,5,6,7] - [4]   => [5,6,7]

    # best_discounted_total 
    # [4,5] discount_amount + [6,7] sum of actual price
    # [4] + [5,6,7]
  end

  def self.discounted_price(price,discount)
    price - (price*(discount/100))
  end
  
  def self.total_discount(items)
    # Convert array of hash [{4=>75.0}, {5=>37.5}, {7=>11.25}, {8=>37.5}, {9=>52.5}], [{4=>75.0}]
    # to {4=>75.0, 5=>37.5, 7=>11.25, 8=>37.5, 9=>52.5}
    items.reduce({}, :merge).values.sum
  end

  def self.apply_discount(item, discount_id)
    discount = Discount.where(id: discount_id).first.discount
    discounted_price(item.price,discount)
  end

  def self.apply_tax(tax, total)
    total += total * tax
  end
end
