class Api::V1::ReplicateController < UsageController
  include OpenrouterConcern
  include ReplicateConcern

  rescue_from RuntimeError do |e|
    render json: { error: e }.to_json, status: 500
  end

  def predict
    prompt = params['prompt']
    raise 'prompt can not be empty' unless prompt.present?

    aspect_ratio = params['aspect_ratio'] || '1:1'

    model_name = params['model']
    final_prompt = case
                     # 添加新的generator的话
                     # 1、需要添加新的predict方法
                     # 2、locale下新的description
                     # 3、lib下my_own_generator 添加内容，并且执行 rails db:seed
                   when model_name.include?('shan/AI-Medal-Generator')
                     openrouter_completion(medal_prompt)
                   when model_name.include?('shan/AI-Anime-Generator')
                     openrouter_completion(anime_prompt)
                   when model_name.include?('shan/AI-Avatar-Generator')
                     openrouter_completion(avatar_prompt)
                   when model_name.include?('shan/AI-Logo-Generator')
                     openrouter_completion(logo_prompt)
                   when model_name.include?('shan/AI-Single-Line-Drawing-Generator')
                     openrouter_completion(single_line_drawing_prompt)
                   when model_name.include?('shan/AI-Food-Photography-Generator')
                     openrouter_completion(food_photography_prompt)
                   else
                     prompt
                   end

    render json: {
      images: gen_img(final_prompt, model_name, aspect_ratio)
    }

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

  private

  def medal_prompt
    <<-DOC
你是一个图片生成 prompt 大师，根据用户给出的内容，生成奖牌的英文 prompt, 奖牌形状是星型，材质是金子。
直接返回prompt内容，不要有其他多余内容
用户输入内容如下：
    DOC
  end

  def anime_prompt
    <<-DOC
你是一个图片生成 prompt 大师，根据用户给出的内容，生成 anime 的英文 prompt
直接返回prompt内容，不要有其他多余内容
用户输入内容如下：
    DOC
  end

  def avatar_prompt
    <<-DOC
你是一个图片生成 prompt 大师，根据用户给出的内容，生成真人头像 avatar 的英文 prompt
直接返回prompt内容，不要有其他多余内容
用户输入内容如下：
    DOC
  end

  def logo_prompt
    <<-DOC
你是一个图片生成 prompt 大师，根据用户给出的内容，生成 branding logo 的英文 prompt
直接返回prompt内容，不要有其他多余内容
用户输入内容如下：
    DOC
  end

  def single_line_drawing_prompt
    <<-DOC
你是一个图片生成 prompt 大师，根据用户给出的内容，生成 single line drawing 的英文 prompt
直接返回prompt内容，不要有其他多余内容
用户输入内容如下：
    DOC
  end

  def food_photography_prompt
    <<-DOC
你是一个图片生成 prompt 大师，根据用户给出的内容，生成 Food Photography 的英文 prompt
直接返回prompt内容，不要有其他多余内容
用户输入内容如下：
    DOC
  end
end
