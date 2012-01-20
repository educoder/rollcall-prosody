module RollcallProsody
  class Railtie < Rails::Railtie
    config.prosody = ActiveSupport::OrderedOptions.new

    initializer 'prosody.initialize' do |app|
      if config.prosody.ctl_path
        RollcallProsody::CTL = config.prosody.ctl_path
      else
        RollcallProsody::CTL = 'prosodyctl'
      end
      
      if config.prosody.domain
        RollcallProsody::DOMAIN = config.prosody.domain
      else
        RollcallProsody::DOMAIN = 'localhost'
      end
      
      require 'account_callbacks'
    end
    
  end
end