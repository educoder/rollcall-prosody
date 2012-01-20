module RollcallProsody::ProsodyCli
  def create_account_in_prosody
    unless @prosody_account_created
      command = %{register "#{self.login}" "#{RollcallProsody::DOMAIN}" "#{self.encrypted_password}"}
      prosody_cli_request(command)
      @prosody_account_created = true unless @prosody_error
    end
  end

  def update_account_in_prosody
    unless @prosody_account_created
      delete_account_in_prosody
      unless @prosody_error
        create_account_in_prosody
        @prosody_account_updated = true unless @prosody_error
      end
    end
  end
  
  def delete_account_in_prosody
    command = %{deluser "#{self.login}@#{RollcallProsody::DOMAIN}"}
    prosody_cli_request(command)
  end
  
  def list_accounts_in_prosody
    raise NotImplementedError
    # command = %{registered-users "#{RollcallProsody::DOMAIN}"}
    # prosody_cli_request(command)
  end
  
  def prosody_account_exists?
    list_accounts_in_prosody.split("\n").include?(login)
  end

  def prosody_cli_request(command)
    ctl = RollcallProsody::CTL

    out = `#{ctl} #{command} 2>&1`
    res = $?.to_i
    
    
    Rails.logger.debug "RollcallProsody::ProsodyCli.prosody_cli_request: #{out}"
    
    if res > 0
      @prosody_error = "Prosody command \n\n\t`#{command}`\n\nwas unssuccessful because:\n\n\t#{out}"
    end
    
    return out
  end
end