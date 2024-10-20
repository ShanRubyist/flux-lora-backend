class Api::V1::OpenrouterController < ApplicationController
  include OpenrouterConcern

  before_action :authenticate_user!

  rescue_from RuntimeError do |e|
    render json: { error: e }.to_json, status: 500
  end

  def completion
    prompt = params['prompt'] || "你是一个图片生成 prompt 大师，根据用户给出的内容，生成对应的prompt, 直接返回prompt内容，不要有其他多余内容"
    content = params['content']
    achieve_id = params['achieve_id'] || SecureRandom.uuid

    raise 'content can not be empty' unless content.present?

    response.headers["Content-Type"] = "application/json"
    response.headers["Last-Modified"] = Time.now.httpdate

    render json: {
      prompt: openrouter_completion(prompt + content)
    }

  end
end
