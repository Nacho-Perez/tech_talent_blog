class Post < ApplicationRecord
    has_many :comments
    belongs_to :user
    
    mount_uploader :picture, PictureUploader
    paginates_per 3
end
