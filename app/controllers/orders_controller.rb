class OrdersController < ApplicationController
  before_action :set_order, only: %i[ show edit update destroy ]

  # GET /orders or /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1 or /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders or /orders.json
  def create
   
    # Extracting item IDs into a separate array
    item_ids = params["order_details"].map { |detail| detail["item_id"] }
    best_discount_id = Discount.find_best_discount(item_ids)
   
    order_total = []
    items = Item.where(id: item_ids).each do |item|
      quantity = params["order_details"].find { |detail| detail["item_id"] == item.id }&.fetch("quantity", 0)
      discount_amount = Discount.apply_discount(item, best_discount_id)
      total_item_price = discount_amount * quantity
      order_total << Discount.apply_tax(item.tax_rate, total_item_price)
    end
   final_total = order_total.sum

   render json: {order_total: final_total}, status: :ok
  end

  # PATCH/PUT /orders/1 or /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to order_url(@order), notice: "Order was successfully updated." }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1 or /orders/1.json
  def destroy
    @order.destroy

    respond_to do |format|
      format.html { redirect_to orders_url, notice: "Order was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params.require(:order).permit(:total_price)
    end
end
