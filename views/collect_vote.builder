xml.Response do
  xml.Gather(:action => '/verify_vote', :finishOnKey => '#') do
    xml.Say('Please enter the number of the competitor you are voting for.')
  end
  xml.Redirect('/collect_vote')
end