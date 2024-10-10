class AttachmentsController < ApplicationController
    before_action :set_perspective
    before_action :set_attachment, only: [ :show, :edit, :update, :destroy, :download ]

    # GET /perspectives/:perspective_id/attachments
    def index
      @attachments = @perspective.attachments
    end

    # GET /perspectives/:perspective_id/attachments/:id
    def show
    end

    # GET /perspectives/:perspective_id/attachments/new
    def new
      @attachment = @perspective.attachments.build
    end

    # POST /perspectives/:perspective_id/attachments
    def create
      @attachment = @perspective.attachments.build(attachment_params)

      if @attachment.save
        redirect_to [ @perspective.post, @perspective ], notice: "Attachment was successfully created."
      else
        render :new
      end
    end

    # GET /perspectives/:perspective_id/attachments/:id/edit
    def edit
    end

    # PATCH/PUT /perspectives/:perspective_id/attachments/:id
    def update
      if @attachment.update(attachment_params)
        redirect_to [ @perspective.post, @perspective ], notice: "Attachment was successfully updated."
      else
        render :edit
      end
    end

    # DELETE /perspectives/:perspective_id/attachments/:id
    def destroy
      @attachment.destroy
      redirect_to [ @perspective.post, @perspective ], notice: "Attachment was successfully destroyed."
    end

    # GET /perspectives/:perspective_id/attachments/:id/download
    def download
      # send_data @attachment.content, filename: @attachment.filename, type: 'application/octet-stream'
    end

    private

      # Set the perspective for nested routes
      def set_perspective
        @perspective = Perspective.find(params[:perspective_id])
      end

      # Set the attachment for actions like show, edit, update, destroy, download
      def set_attachment
        @attachment = @perspective.attachments.find(params[:id])
      end

      # Strong parameters: Only allow the trusted parameters for attachment
      def attachment_params
        params.require(:attachment).permit(:filename, :content, :status)
      end
end
