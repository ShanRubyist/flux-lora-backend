class Api::V1::LoraController < ApplicationController

  def index
    category = params[:category]
    lora_category = case category.to_i
                    when 1
                      Lora.where('runs > ?', 1000).order('runs desc')
                    when 2
                      Lora.where('created_at >= ?', 7.days.ago).order('created_at desc')
                    else
                      Lora.all
                    end

    loras = lora_category.map do |lora|
      {
        name: I18n.t('lora.name', model_name: lora.name, cost_credits: lora.cost_credits),
        value: lora.value,
        cost_credits: lora.cost_credits,
        runs: lora.runs,
        seo_title: I18n.t('lora.title', model: lora.value),
        seo_description: I18n.t('lora.description', model: lora.value),
        h1: I18n.t('lora.h1', model: lora.value),
        h1_p: I18n.t('lora.h1_p', model: lora.value),
        lora_description: I18n.t("lora.lora_description.#{lora.value}", default: ''),
        example_pics: lora.showcases.map {|i| { id: i.id, image: (url_for(i.image) rescue nil) }}
      }
    end

    render json: loras
  end

  def show
    lora = Lora.find_by(name: params[:id])
    if lora
      render json: {
        value: lora.value,
        example_pics: lora.showcases.map {|i| { id: i.id, image: url_for(i.image) }}
      }
    else
      render json: {
        message: "#{params[:name]} not exist"
      }, status: 400
    end

  end

end