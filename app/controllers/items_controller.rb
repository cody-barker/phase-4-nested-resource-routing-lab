class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  def index
    if params[:user_id]
      user = find_user
      items = user.items
    else
      items = Item.all
    end
    render json: items, include: :user
  end

  def show
    item = find_item
    render json: item, include: :user
  end

  # /users/:user_id/items
  def create
    user = User.find(params[:user_id])
    new_item = Item.create(
      name: params[:name],
      description: params[:description],
      price: params[:price]
    )
    user.items << new_item
    render json: user, include: :items, status: :created
    new_item
  end

  private

  def find_item
    Item.find(params[:id])
  end

  def find_user
    User.find(params[:user_id])
  end

  def item_params
  end

  def render_not_found_response
    render json: { error: "User not found" }, status: :not_found
  end

end
