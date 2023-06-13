# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Create Items

items = Item.create([
  { id: 1, name: 'Regular Coffee', price: '30', tax_rate: 2}, 
  { id: 2, name: 'Latte', price: '40', tax_rate: 2},
  { id: 3, name: 'Tea', price: '15', tax_rate: 0},
  { id: 4, name: 'Burger', price: '100', tax_rate: 5},
  { id: 5, name: 'Sandwitch', price: '50', tax_rate: 3},
  { id: 6, name: 'Bhel', price: '15', tax_rate: 2},
  { id: 7, name: 'Panipuri', price: '15', tax_rate: 2},
  { id: 8, name: 'Fries', price: '50', tax_rate: 3},
  { id: 9, name: 'Cake', price: '70', tax_rate: 2},
  { id: 10, name: 'Sprite', price: '20', tax_rate: 2},
])

Discount.create([
  {item_ids: '6,7,8', discount: 10, discount_amount: nil, discounted_item_id: nil},
  {item_ids: '1,8,9,10', discount: 20, discount_amount: nil, discounted_item_id: nil},
  {item_ids: '4,5,7,8,9', discount: 25, discount_amount: nil, discounted_item_id: nil},
  {item_ids: '4,5', discount: 30, discount_amount: nil, discounted_item_id: nil},
  {item_ids: '4', discount: 10, discount_amount: nil, discounted_item_id: nil}
])