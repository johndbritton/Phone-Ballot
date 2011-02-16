xml.Response do
  xml.Say('Welcome to the voting line. Powered by Twilio.')
  xml.Redirect('/authorize_phone')
end