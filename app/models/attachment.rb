# == Schema Information
#
# Table name: attachments
#
#  id             :bigint           not null, primary key
#  perspective_id :bigint           not null
#  filename       :string
#  type_content   :string
#  content        :binary
#  status         :string           default("in_analysis")
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_attachments_on_perspective_id  (perspective_id)
#
# Foreign Keys
#
#  fk_rails_...  (perspective_id => perspectives.id)
#
require "marcel"
require "streamio-ffmpeg"
class Attachment < ApplicationRecord
  # Examples of type_content: image/jpeg, video/quicktime, cloud (links)
  belongs_to :perspective

  has_many :attachmentcounters, dependent: :destroy

  validates :filename, presence: true
  validates :status, inclusion: { in: %w[approved in_analysis rejected] }

  after_create_commit   :generate_smaller_version
  after_destroy_commit  :destroy_smaller_version

  def self.update_preview_images
    Attachment.find_in_batches(batch_size: 100) do |attachments|
      attachments.each do |attachment|
        begin
          attachment.send(:destroy_smaller_version)
          attachment.send(:generate_smaller_version)
        rescue => e
          Rails.logger.error "Failed to update preview image for Attachment ID: #{attachment.id}. Error: #{e.message}"
        end
      end
    end
  end

  def preview_image_url
    return unless content.present?

    post = perspective.post
    "/calendars/#{post.calendar.id}/posts/#{post.id}/perspectives/#{perspective.id}/attachments/#{id}"
  end

  private

  def resized_image(width:, height:)
    return unless content.present?

    original_file = Tempfile.new([ "#{id}_smaller", ".jpg" ])
    original_file.binmode
    original_file.write(content)
    original_file.rewind

    resized_file = ImageProcessing::MiniMagick
                   .source(original_file)
                   .resize_to_limit(width, height)
                   .call

    # Read the resized image into binary format
    resized_binary = File.binread(resized_file.path)

    original_file.close
    resized_file.close
    resized_binary
  end

  def file_type
    mime_type = Marcel::MimeType.for(content, name: filename)

    case mime_type
    when /^image\//
      :image
    when /^video\//
      :video
    else
      :unknown
    end
  end

  def generate_smaller_version
    mime_type = file_type
    return unless mime_type == :image || mime_type == :video
    return unless content.present?

    return generate_video_banner if mime_type == :video

    smaller_binary = resized_image(width: 300, height: 300)
    smaller_file_path = Rails.root.join("public/system/attachments", "#{id}_smaller.jpg")

    FileUtils.mkdir_p(File.dirname(smaller_file_path))
    File.open(smaller_file_path, "wb") { |file| file.write(smaller_binary) }
  end

  def generate_video_banner
    return unless content.present?

    # Create a temporary file to store the video content
    video_path = Tempfile.new([ "video", ".mp4" ])
    video_path.binmode
    video_path.write(content)
    video_path.rewind

    # Initialize the FFMPEG movie object
    movie = FFMPEG::Movie.new(video_path.path)

    # Choose a frame at 10% of the video's duration or the first frame
    frame_time = movie.duration * 0.1 rescue 0
    banner_path = Rails.root.join("public/system/attachments/#{id}_smaller.jpg")
    FileUtils.mkdir_p(File.dirname(banner_path))

    if movie.valid?
      movie.screenshot(banner_path.to_s, { seek_time: frame_time, resolution: "400x300" })
      puts "Banner generated at #{banner_path}"
    else
      puts "Invalid video file: #{video_path}"
    end
  ensure
    # Clean up the temporary video file
    video_path.close
    video_path.unlink
  end

  def destroy_smaller_version
    smaller_file_path = Rails.root.join("public/system/attachments", "#{id}_smaller.jpg")
    File.delete(smaller_file_path) if File.exist?(smaller_file_path)
  end
end
