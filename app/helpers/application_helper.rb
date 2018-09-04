module ApplicationHelper
  def pixel_tag
    if Rails.env == 'production'
      domain = 'https://dogoodpoints.herokuapp.com'
      client_key =  Rails.application.credentials.dgp_client_key
    else
      domain = 'http://localhost:3000'
      client_key = 'XxAZecFtTNNOjg'
    end
    tag(:image,
        src: "#{domain}/track?client_key=#{client_key}",
        style: "display: none;")
  end
end
