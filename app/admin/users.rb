ActiveAdmin.register User do
  permit_params :email, :organization_id, :isLeader

  index do
    selectable_column
    id_column
    column :email
    column :organization
    column :isLeader
    column :created_at
    column :updated_at
    actions
  end

  filter :email
  filter :organization
  filter :created_at
  filter :updated_at
  filter :isLeader

  form do |f|
    f.inputs do
      f.input :email
      f.input :organization
      f.input :isLeader
    end
    f.actions do
      f.action :submit 
      f.action :cancel, wrapper_html: {class: :cancel}
    end
  end

  controller do
    def create
      @user = User.new(permitted_params[:user])
      @user.password = Devise.friendly_token.first(8)

      respond_to do |format|
        if @user.save
          @user.send_reset_password_instructions
          format.html { redirect_to admin_user_path(@user), notice: "User was successfully created." }
        else
          format.html { render :new, status: :unprocessable_entity }
        end
      end
    end
  end
end
