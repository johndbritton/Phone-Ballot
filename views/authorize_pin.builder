xml.Response do
  xml.Response(:action => '/authorize_pin', :finishOnKey => '#') do
    xml.Say('Please enter your voting pin.')
  end
end