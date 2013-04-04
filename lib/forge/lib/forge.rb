module Forge
  Forge::Application.config.after_initialization do
    require 'forge/settings'
    require 'forge/credit_card_processor'
    require 'forge/form_helper'
  end
end