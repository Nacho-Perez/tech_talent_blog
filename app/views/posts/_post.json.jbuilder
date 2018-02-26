json.extract! post, :id, :title, :author, :input_blog, :created_at, :updated_at
json.url post_url(post, format: :json)
