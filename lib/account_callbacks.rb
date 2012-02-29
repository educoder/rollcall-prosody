require 'uri'
require 'account'

Account.class_eval do
  unless Rails.env == 'test'
    require 'prosody_cli'
    include RollcallProsody::ProsodyCli
    Rails.logger.debug "Loaded Prosody CLI connector for domain #{RollcallProsody::DOMAIN}."
  
    before_create :create_account_in_prosody, :if => proc{ !login.blank? && !password.blank? }
    before_update :update_account_in_prosody, :if => proc{ !login.blank? && !password.blank? && password_changed? }
    before_destroy :delete_account_in_prosody
  
    validate do
      # if !@prosody_error && !prosody_account_exists?
      #   @prosody_error = "#{login}@#{Rollcallprosody::DOMAIN} cannot be updated because it does not exist on the ejabbberd server!"
      # end
      
      self.errors[:base] << @prosody_error if @prosody_error
    end
  end
end