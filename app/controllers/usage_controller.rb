class UsageController < ApplicationController
  before_action :authenticate_user!

  include Usage
  before_action :check_credits, only: [:predict]

  private

  def check_credits
    unless credits_enough?
      render json: {
        message: 'You do not has enough credits'
      }.to_json, status: 403
    end
  end

  def current_cost_credits
    case params[:model]
    when nil
      1
    else
      Lora.find_by(value: params[:model]).cost_credits
    end
  end
end