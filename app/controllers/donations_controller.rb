class DonationsController < ApplicationController
  before_action :set_cause, only: [:show, :edit, :update, :destroy]

  def index
    @donations = Donation.all
  end

  def new
    @cause = Cause.find(params[:cause_id])
    @donation = @cause.donations.new
  end

  def create
    @cause = Cause.find(params[:cause_id])
    @donation = @cause.donations.new(donation_params)
    if @donation.save
      #report conversion on half of the causes to test pixel-only integration
      report_conversion(@donation) if @cause.id % 2 == 0
      redirect_to '/payment_confirmation'
    else
      render 'new'
    end
  end

  def confirmation
  end

  def destroy
  end

  private

  def set_cause
    @donation = Donation.find(params[:id])
  end

  def donation_params
    params.require(:donation).permit(:full_name, :email, :postal_code, :amount, :source, :external_id )
  end

  #adapter for reporting to traffic source platforms
  def report_conversion(donation)
    if donation.source == 'dgp'
      report_dgp_conversion(donation.external_id)
    elsif donation.source == 'swagbucks'
      #report_swagbucks_conversion(donation.external_id)
    end
  end

  #Integration with Do Good Points
  def report_dgp_conversion(external_id)
    Rails.env == "production" ? url = "https://dogoodpoints.herokuapp.com" : url = 'http://localhost:3000'
    conn = Faraday.new(url: url) do |faraday|
      faraday.token_auth('2nrWLIoHwpR72w')
    end
    response = conn.post do |req|
      req.url '/conversions'
      req.headers['Content-Type'] = 'application/json'
      req.body = { engagement: external_id }
    end
  end
end
