# frozen_string_literal: true
ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "Recent Users" do
          ul do
            User.recent(5).map do |user|
              li link_to(user.email, admin_user_path(user))
            end
          end
        end
      end
      column do
        panel "Recent Organizations" do
          ul do
            Organization.recent(5).map do |organization|
              li link_to(organization.name, admin_organization_path(organization))
            end
          end
        end
      end
    end
  end
end
