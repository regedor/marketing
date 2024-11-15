class CompanylinksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company
  before_action :check_organization!
  before_action :set_companylink, only: [ :destroy_content ]

  # POST /companies/:company_id/companylinks/
  def create
    @companylink = @company.companylinks.new(companylinks_params)

    if !url?(params[:companylink][:link])
      redirect_to company_path(@company),  alert: "Not a valid URL"
      return
    end

    begin
      if @companylink.save
        redirect_to company_path(@company), notice: "Entry was successfully created."
      else
        redirect_to company_path(@company), alert: "Failed to add entry due to validation errors."
      end
    rescue ActiveRecord::RecordNotUnique
      redirect_to company_path(@company), alert: "Entry already exists for this company."
    end
  end

  # DELETE /companies/:company_id/companylinks/:id/destroy_content
  def destroy_content
    puts "\n==CONTROLLER=="
    puts "company: ", @company.id
    puts "companylink: ", @companylink
    if @companylink.destroy
      redirect_to company_path(@company), notice: "Content removed successfully."
    else
      redirect_to company_path(@company), alert: "Failed to remove content."
    end
  end

  private

    def check_organization!
      redirect_to request.referrer || root_path, alert: "Access Denied" unless current_user.organization_id == @company.organization.id
    end

    def set_company
      @company = Company.find(params[:company_id])
    end

    def set_companylink
      @companylink = @company.companylinks.find_by(name: params[:name])
    end


    def companylinks_params
      params.require(:companylink).permit(:name, :link)
    end

    def url?(string)
      uri = URI.parse(string)
      uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
    rescue URI::InvalidURIError
      false
    end
end
