class LeadsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_pipeline
  before_action :check_organization!
  before_action :set_companies_people
  before_action :set_lead, only: %i[ show edit update destroy update_stage]

  # GET /leads/
  def show
    lead_notes = @lead.leadnotes.map { |ln| { id: ln.id, note: ln.note, type: "lead", author: ln.member.email, to: @lead.name, datetime: ln.created_at, link: pipeline_lead_path(@pipeline, @lead) } }
    if @pipeline.to_people
      person_notes =  @lead.person.personnotes.map { |pn| { id: pn.id, note: pn.note, type: "person", to: pn.person.name, author: pn.member.email,  datetime: pn.created_at, link: person_path(pn.person) } }
      @notes = (lead_notes + person_notes)
    else
      company = @lead.company
      company_notes = company.companynotes.map { |cn| { id: cn.id, note: cn.note, type: "company", author: cn.member.email, to: company.name, datetime: cn.created_at, link: company_path(company) } }
      person_company_notes =  company.personcompanies.select { |pc| pc.person.is_private == false || pc.person.member == current_member }.map { |pc| pc.person.personnotes }.flatten.map { |pn| { id: pn.id, note: pn.note, type: "person", to: pn.person.name, author: pn.member.email,  datetime: pn.created_at, link: person_path(pn.person) } }
      @notes = (lead_notes + company_notes + person_company_notes)
    end
    @notes = @notes.sort { |a, b| b[:datetime] <=> a[:datetime] }
    @new_lead_note = @lead.leadnotes.new
  end

  # GET /pipeline/:pipeline_id/leads/new
  def new
    @lead = Lead.new
  end

  # GET /pipeline/:pipeline_id/leads/:id/edit
  def edit
  end

  # GET /pipeline/:pipeline_id/leads/
  def create
    if @pipeline.to_people
      @lead = @pipeline.leads.new(lead_person_params)
    else
      @lead = @pipeline.leads.new(lead_company_params)
    end
    if check_company_people(:new)
      @lead.stage = @pipeline.stages.sort_by { |s| s.index }.first
      @pipeline.pipeattributes.each do |pa|
        @lead.leadcontents.new(value: "", lead: @lead, pipeattribute: pa)
      end

      if @lead.save
        redirect_to pipeline_lead_path(@pipeline, @lead), notice: "Lead was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  # PATCH /pipeline/:pipeline_id/leads/:id
  def update
    if @pipeline.to_people
      b = @lead.update(lead_person_params)
    else
      b = @lead.update(lead_company_params)
    end
    if b
      redirect_to pipeline_lead_path(@pipeline, @lead), notice: "Lead was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /pipeline/:pipeline_id/leads/:id
  def destroy
    @lead.destroy!
    redirect_to pipeline_path(@pipeline), notice: "Lead was successfully destroyed."
  end

  def update_stage
    if @lead.update(lead_stage_params)
      redirect_to pipeline_lead_path(@pipeline, @lead), notice: "Stage was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lead
      @lead = @pipeline.leads.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def lead_company_params
      params.require(:lead).permit(:name, :start_date, :end_date, :description, :company_id)
    end

    def lead_person_params
      params.require(:lead).permit(:name, :start_date, :end_date, :description, :person_id)
    end

    # Only allow a list of trusted parameters through.
    def lead_stage_params
      params.require(:lead).permit(:stage_id)
    end

    def set_pipeline
      @pipeline = Pipeline.find(params[:pipeline_id])
    end

    def check_organization!
      redirect_to request.referrer || root_path, alert: "Access Denied" unless current_member.organization_id == @pipeline.organization_id
    end

    def set_companies_people
      @companies = Company.where(organization: current_member.organization)
      @people = Person.where(organization: current_member.organization).where("is_private = ? OR member_id = ?", false, current_member.id)
    end

    def check_company_people(page)
      if @pipeline.to_people
        if !@people.map { |p| p.id }.include? params[:lead][:person_id].to_i
          @lead.errors.add(:base, "Not a valid person")
          render page, status: :unprocessable_entity
          false
        else
          true
        end
      else
        if !@companies.map { |c| c.id }.include? params[:lead][:company_id].to_i
          @lead.errors.add(:base, "Not a valid company")
          render page, status: :unprocessable_entity
          false
        else
          true
        end
      end
    end
end
