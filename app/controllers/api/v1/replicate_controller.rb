class Api::V1::ReplicateController < UsageController
  rescue_from RuntimeError do |e|
    render json: { error: e }.to_json, status: 500
  end

  def predict
    prompt = params['prompt']
    raise 'prompt can not be empty' unless prompt.present?

    aspect_ratio = params['aspect_ratio'] || '1:1'

    model_name = params['model'] || 'black-forest-labs/flux-schnell'
    model = Replicate.client.retrieve_model(model_name)
    version = model.latest_version

    begin
      # webhook_url = "https://" + ENV.fetch("HOST") + "/replicate/webhook"
      prediction = version.predict(prompt: prompt, aspect_ratio: aspect_ratio, disable_safety_checker: true) #, safety_tolerance: 5)
      data = prediction.refetch

      until prediction.finished? do
        sleep 1
        data = prediction.refetch
      end

      raise data.fetch('error') if prediction.failed? || prediction.canceled?

      render json: {
        images: prediction.output
      }
    ensure
      params.permit(:prompt, :aspect_ratio, :model, :replicate)
      SavePicToOssJob.perform_later({ user: current_user, model_name: model_name, aspect_ratio: aspect_ratio, prompt: prompt, data: data })
    end
  end

  def index
    params[:page] ||= 1
    params[:per] ||= 20

    replicated_calls = current_user
                         .replicated_calls
                         .order("created_at desc")
                         .page(params[:page].to_i)
                         .per(params[:per].to_i)

    result = replicated_calls.map do |item|
      {
        image: (url_for(item.image) rescue nil),
        prompt: item.prompt,
        created_at: item.created_at,
        aspect_ratio: item.aspect_ratio,
        cost_credits: item.cost_credits,
        model: item.model&.sub("black-forest-labs/", ''),
        status: item.data.fetch('status') { nil },
        id: item.predict_id
      }
    end

    render json: {
      total: replicated_calls.total_count,
      histories: result
    }
  end

  def show
    item = current_user.replicated_calls.find_by(predict_id: params[:id])
    if item
      render json: {
        seo_title: I18n.t('image.title', prompt: item.prompt, default: ''),
        seo_description: I18n.t('image.description', prompt: item.prompt, default: ''),
        h1: I18n.t('image.h1', prompt: item.prompt),
        h1_p: I18n.t('image.h1_p', prompt: item.prompt, default: ''),
        image: (url_for(item.image) rescue nil),
        prompt: item.prompt,
        created_at: item.created_at,
        aspect_ratio: item.aspect_ratio,
        cost_credits: item.cost_credits,
        model: item.model&.sub("black-forest-labs/", ''),
        status: item.data.fetch('status') { nil }
      }
    else
      render json: {
        message: "#{params[:id]} not exist"
      }, status: 400
    end
  end
end
