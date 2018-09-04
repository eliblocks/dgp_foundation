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
      # API call for Even-numbered offers
      if @cause.id % 2 == 0
        report_conversion(@donation)
        redirect_to root_path
      else
        redirect_to '/payment_confirmation'
      end
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
      donation.report_dgp_conversion
    elsif donation.source == 'swagbucks'
      #report_swagbucks_conversion(donation)
    end
  end



end
