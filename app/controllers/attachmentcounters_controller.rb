class AttachmentcountersController < ApplicationController
    before_action :set_attachment
    before_action :set_attachmentcounter, only: [:edit, :update, :destroy]
  
    def index
      @attachmentcounters = @attachment.attachmentcounters
    end
  
    def new
      @attachmentcounter = @attachment.attachmentcounters.build
    end
  
    def create
      @attachmentcounter = @attachment.attachmentcounters.build(attachmentcounter_params)
      @attachmentcounter.user = current_user
  
      if @attachmentcounter.save
        redirect_to perspective_attachment_path(@attachment.perspective, @attachment), notice: "Attachment counter created successfully."
      else
        render :new
      end
    end
  
    def edit
    end
  
    def update
      if @attachmentcounter.update(attachmentcounter_params)
        redirect_to perspective_attachment_path(@attachment.perspective, @attachment), notice: "Attachment counter updated successfully."
      else
        render :edit
      end
    end
  
    def destroy
      @attachmentcounter.destroy
      redirect_to perspective_attachment_path(@attachment.perspective, @attachment), notice: "Attachment counter deleted."
    end
  
    private
  
    def set_attachment
      @attachment = Attachment.find(params[:attachment_id])
    end
  
    def set_attachmentcounter
      @attachmentcounter = @attachment.attachmentcounters.find(params[:id])
    end
  
    def attachmentcounter_params
      params.require(:attachmentcounter).permit(:aproved, :rejected)
    end
  end
  