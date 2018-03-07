Rails.application.routes.draw do
  get '/jwt', 
    to: 'jwt#get'

  get '/jwk/:kid', 
    to: 'jwk#get'
end
