module ReplicateConcern
  extend ActiveSupport::Concern

  included do |base|
  end

  def gen_img(prompt, model_name, aspect_ratio)
    if model_name.start_with?('shan/')
      model = Replicate.client.retrieve_model('black-forest-labs/flux-schnell')
    else
      model = Replicate.client.retrieve_model(model_name)
    end

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

    ensure
      # params.permit(:prompt, :aspect_ratio, :model, :replicate)
      SavePicToOssJob.perform_later({ user: current_user, model_name: model_name, aspect_ratio: aspect_ratio, prompt: prompt, data: data })
    end

    prediction.output
  end

  module ClassMethods
  end
end
