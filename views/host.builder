xml.Response do
  xml.Gather(:action => '/winner', :numDigits => '1') do
    xml.Say('Welcome to the contest host line, powered by Twilio.')
    xml.Say('After you are connected, you can press star to disconnect.')
    xml.Say('We will then select another winner.')
    xml.Say('Press 1 to select from the voters who picked the first place winner.')
    xml.Say('Press 2 to select from the voters who picked the second place winner.')
    xml.Say('Press 3 to select from the voters who picked the third place winner.')
    xml.Say('Press 9 to select from the voters who picked one of the top three winners.')
    xml.Say('Press 0 to select from all voters.')
  end
  xml.Redirect('/host')
end