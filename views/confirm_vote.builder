xml.Response do
  xml.Sms("Thank you for voting for #{@competitor.name}. Powered by Twilio. http://twilio.com")
  xml.Say("Thank you for voting for #{@competitor.name}. Powered by Twilio.")
end