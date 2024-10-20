require "ruby/openai"

module Bot
  class Openrouter
    def initialize(api_key=ENV.fetch('OPENROUTER_TOKEN'), api_base_url = 'https://openrouter.ai/api/', organization_id = '')
      @client = openai_client(api_key, api_base_url, organization_id)
      @model = 'openai/o1-mini'
    end

    def handle(content, prompt = nil, options = {}, &block)
      @model = options.fetch(:model, @model)
      @temperature = options.fetch(:temperature, 1)
      @top_p = options.fetch(:top_p, 1)
      @stream = options.fetch(:stream, false)

      message = []
      message.push({ "role": "system", "content": prompt }) if prompt
      message.push({ "role": "user", "content": content })

      @client.chat(
        parameters: {
          model: @model,
          messages: message,
          # temperature: @temperature,
          # top_p: @top_p,
        })
    end

    private

    def openai_client(access_token, uri_base, organization_id = '', request_timeout = 240)
      ::OpenAI.configure do |config|
        config.access_token = access_token
        config.uri_base = uri_base
        config.organization_id = organization_id
        config.request_timeout = request_timeout
      end

      ::OpenAI::Client.new
    end
  end
end