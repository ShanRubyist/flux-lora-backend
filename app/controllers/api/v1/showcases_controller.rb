class Api::V1::ShowcasesController < ApplicationController
  before_action :set_showcase, only: %i[ show update destroy ]

  # GET /showcases
  def index
    @showcases = Showcase.all

    render json: @showcases.map { |showcase|
      {
        showcase: showcase,
        image: url_for(showcase.image),
      }
    }
  end

  # GET /showcases/1
  def show
    render json: {
      seo_title: I18n.t('showcase.title', prompt: @showcase.prompt, default: ''),
      seo_description: I18n.t('showcase.description', prompt: @showcase.prompt, default: ''),
      h1: I18n.t('showcase.h1', prompt: @showcase.prompt),
      h1_p: I18n.t('showcase.h1_p', prompt: @showcase.prompt, default: ''),
      showcase: @showcase,
      image: url_for(@showcase.image)
    }
  end

  # POST /showcases
  def create
    @showcase = Showcase.new(showcase_params)

    if @showcase.save
      render json: @showcase, status: :created, location: @showcase
    else
      render json: @showcase.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /showcases/1
  def update
    if @showcase.update(showcase_params)
      render json: @showcase
    else
      render json: @showcase.errors, status: :unprocessable_entity
    end
  end

  # DELETE /showcases/1
  def destroy
    @showcase.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_showcase
    @showcase = Showcase.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def showcase_params
    params.fetch(:showcase, {})
  end
end
