Rails.application.routes.draw do

  root 'welcome#index'

  get '/data', to: 'welcome#data'
  put '/scramble', to: 'welcome#scramble'
end
