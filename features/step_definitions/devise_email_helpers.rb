module DeviseMailHelpers
  def extract_token_from_email(email, token_name)
    body = email.body.to_s
    body[/#{token_name.to_s}=([^"]+)/, 1]
  end
end

World(DeviseMailHelpers)
