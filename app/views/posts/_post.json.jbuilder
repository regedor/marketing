json.extract! post, :id, :title, :user_id, :calendar_id, :status, :publish_date, :created_at, :updated_at
json.url post_url(post, format: :json)
