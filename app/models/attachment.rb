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
#  attachment_id  :bigint
#
# Indexes
#
#  index_attachments_on_attachment_id   (attachment_id)
#  index_attachments_on_perspective_id  (perspective_id)
#
# Foreign Keys
#
#  fk_rails_...  (attachment_id => attachments.id)
#  fk_rails_...  (perspective_id => perspectives.id)
#
require "marcel"
require "streamio-ffmpeg"
class Attachment < ApplicationRecord
  include Rails.application.routes.url_helpers

  # Examples of type_content: image/jpeg, video/quicktime, cloud (links)
  belongs_to :perspective
  belongs_to :original_attachment,
    class_name: "Attachment",
    foreign_key: :attachment_id,
    inverse_of: :preview_file,
    optional: true

  has_many :attachmentcounters, dependent: :destroy
  has_one :preview_file,
    class_name: "Attachment",
    foreign_key: :attachment_id,
    dependent: :destroy,
    inverse_of: :original_attachment

  validates :filename, presence: true
  validates :status, inclusion: { in: %w[approved in_analysis rejected] }

  def is_preview?
    attachment_id.present?
  end

  def generate_preview
    return if attachment_id.present?

    generate_smaller_version
  end

  def self.update_preview_images
    Attachment.find_in_batches(batch_size: 100) do |attachments|
      attachments.each do |attachment|
        begin
          next if attachment.preview_file.present?

          generate_smaller_version
        rescue => e
          Rails.logger.error "Failed to update preview image for Attachment ID: #{attachment.id}. Error: #{e.message}"
        end
      end
    end
  end

  def preview_image_url
    post = perspective.post
    preview_id = preview_file&.id
    if preview_id.blank? && attachment_id.blank?
      self.reload
      generate_smaller_version
      preview_id = preview_file&.id || id
    end
    calendar_post_perspective_attachment_path(post.calendar.id, post.id, perspective.id, preview_id)
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
    return if Attachment.exists?(attachment_id: id)
    mime_type = file_type
    return unless mime_type == :image || mime_type == :video
    return unless content.present?

    return generate_video_banner if mime_type == :video

    smaller_binary = resized_image(width: 300, height: 300)
    preview_attachment = Attachment.create!(perspective_id: perspective_id, filename: filename,
      type_content: type_content, content: smaller_binary, status: status, original_attachment: self)
    preview_attachment
  end

  def generate_video_banner
    return unless content.present?

    # Create a temporary file to store the video content
    video_path = Tempfile.new([ "video", ".mp4" ])
    video_path.binmode
    video_path.write(content)
    video_path.rewind

    movie = FFMPEG::Movie.new(video_path.path)
    # Choose a frame at 10% of the video's duration or the first frame
    frame_time = movie.duration * 0.1 rescue 0

    if movie.valid?
      # Create a temporary file for the screenshot
      banner_tempfile = Tempfile.new([ "screenshot", ".jpg" ])

      # Generate the screenshot
      movie.screenshot(banner_tempfile.path, { seek_time: frame_time, resolution: "400x300" })

      # Read the screenshot content into a binary format
      screenshot_content = File.binread(banner_tempfile.path)

      # Save the screenshot as a new Attachment record
      Attachment.create!(
        perspective: self.perspective, # Adjust to associate with the correct perspective
        type_content: "image/jpeg",
        filename: "#{filename}_preview.jpg",
        content: screenshot_content,
        original_attachment: self
      )
    else
      puts "Invalid video file: #{video_path.path}"
    end
  ensure
    # Clean up temporary files
    video_path.close
    video_path.unlink
    banner_tempfile&.close
    banner_tempfile&.unlink
  end
end
