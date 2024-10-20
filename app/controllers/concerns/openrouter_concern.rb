require 'openrouter'

module OpenrouterConcern
  extend ActiveSupport::Concern

  included do |base|
  end

  def openrouter_completion(prompt)
    client = Bot::Openrouter.new
    options = {}

    begin
      result = client.handle(prompt, prompt, options)
    ensure
    end

    result['choices'][0]['message']['content']
  end

  module ClassMethods
  end
end
