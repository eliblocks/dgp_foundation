class Donation < ApplicationRecord
  belongs_to :cause

  def report_dgp_conversion
    if Rails.env == "production"
      url = "https://dogoodpoints.herokuapp.com/api/conversions"
      secret = Rails.application.credentials.dgp_secret
    else
      url = 'http://localhost:3000/api/conversions'
      secret = 'oX7qB4nY3IwFjMHws1au'
    end

    RestClient.post(url, { engagement_id: external_id },
                          { "Authorization" => "Token #{secret}" })
  end
end
