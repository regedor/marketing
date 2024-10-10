class PerspectivesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_post
    before_action :set_perspective, only: [ :show, :edit, :update, :destroy ]

    # GET /posts/:post_id/perspectives
    def index
      @perspectives = @post.perspectives
    end

    # GET /posts/:post_id/perspectives/:id
    def show
      @next_perspective = @post.perspectives.where("id > ?", @perspective.id).first
      @previous_perspective = @post.perspectives.where("id < ?", @perspective.id).last
    end

    # GET /posts/:post_id/perspectives/new
    def new
      @perspective = @post.perspectives.build
    end

    # POST /posts/:post_id/perspectives
    def create
      @perspective = @post.perspectives.build(perspective_params)

      if @perspective.save
        redirect_to [ @post, @perspective ], notice: "Perspective was successfully created."
      else
        render :new
      end
    end

    # GET /posts/:post_id/perspectives/:id/edit
    def edit
    end

    # PATCH/PUT /posts/:post_id/perspectives/:id
    def update
      if @perspective.update(perspective_params)
        redirect_to [ @post, @perspective ], notice: "Perspective was successfully updated."
      else
        render :edit
      end
    end

    # DELETE /posts/:post_id/perspectives/:id
    def destroy
      @perspective.destroy
      redirect_to post_perspectives_path(@post), notice: "Perspective was successfully destroyed."
    end

    private

    # Set the post for nested routes
    def set_post
      @post = Post.find(params[:post_id])
    end

    # Set the perspective for actions like show, edit, update, destroy
    def set_perspective
      @perspective = @post.perspectives.find(params[:id])
    end

    # Strong parameters: Only allow the trusted parameters for perspective
    def perspective_params
      params.require(:perspective).permit(:copy, :socialplatform_id, :status)
    end
end
