class Api::V1::LoraController < ApplicationController

  def index
    category = case params[:category].to_i
                    when 1
                      Lora.where('runs > ?', 1000).order('runs desc')
                    when 2
                      Lora.where('created_at >= ?', 7.days.ago).order('created_at desc')
                    else
                      Lora.all
                    end

    loras = category.where('t like ?', 'lora').map do |lora|
      display_name = lora.value.split('/').last.split('-').map(&:capitalize).join(' ')

      {
        name: I18n.t('lora.name', model_name: lora.name, cost_credits: lora.cost_credits),
        display_name: display_name,
        value: lora.value,
        cost_credits: lora.cost_credits,
        runs: lora.runs,
        seo_title: I18n.t('lora.title', model: display_name),
        seo_description: I18n.t('lora.description', model: display_name),
        h1: I18n.t('lora.h1', model: display_name),
        h1_p: I18n.t('lora.h1_p', model: display_name),
        lora_description: I18n.t("lora.lora_description.#{lora.value}", default: ''),
        example_pics: lora.showcases.map {|i| { id: i.id, image: (url_for(i.image) rescue nil) }}
      }
    end

    tools = category.where('t like ?', 'tool').map do |lora|
      display_name = lora.value.split('/').last.split('-').map(&:capitalize).join(' ')
                       .gsub('Ai', 'AI')

      {
        name: I18n.t('tool.name', model_name: lora.name, cost_credits: lora.cost_credits),
        display_name: display_name,
        value: lora.value,
        cost_credits: lora.cost_credits,
        runs: lora.runs,
        seo_title: I18n.t('tool.title', model: display_name),
        seo_description: I18n.t('tool.description', model: display_name),
        h1: I18n.t('tool.h1', model: display_name),
        h1_p: I18n.t('tool.h1_p', model: display_name),
        lora_description: I18n.t("tool.tool_description.#{lora.value}", default: ''),
        example_pics: lora.showcases.map {|i| { id: i.id, image: (url_for(i.image) rescue nil) }}
      }
    end

    render json: loras + tools
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