# frozen_string_literal: true

class FileInput < Formtastic::Inputs::FileInput
  def to_html
    input_wrapping do
      label_html <<
        builder.file_field(method, input_html_options) <<
        image_preview_content <<
        images_preview_content <<
        file_preview_content
    end
  end

  private

  # File preview
  def image_preview_content
    image_preview? ? image_preview_html : ''
  end

  def image_preview?
    options[:image_preview] && @object.send(method).attached?
  end

  def image_preview_html
    template.content_tag(
      :p,
      image_link,
      class: builder.default_hint_class
    )
  end

  def image_link
    template.link_to image_tag_or_text(@object.send(method)), @object.send(method)
  end

  def image_tag_or_text(image)
    template.image_tag(image_url(image), class: 'image-preview')
  rescue StandardError
    @object.send(method).filename
  end

  def image_url(image)
    return image.preview(resize: '100x100>', auto_orient: true) if image.previewable?

    image.variant(resize: '100x100>', auto_orient: true)
  end

  # Images preview
  def images_preview_content
    images_preview? ? images_preview_html : ''
  end

  def images_preview?
    options[:images_preview] && @object.send(method).any?
  end

  def images_preview_html
    template.content_tag(
      :p,
      images_links,
      class: builder.default_hint_class
    )
  end

  def images_links
    template.raw(@object.send(method).map do |image|
      template.link_to image_tag_or_text(image), image
    end.join(' '))
  end

  # File preview
  def file_preview_content
    file_preview? ? file_preview_html : ''
  end

  def file_preview?
    options[:file_preview] && @object.send(method).attached?
  end

  def file_preview_html
    template.content_tag(
      :p,
      file_tag_or_text,
      class: builder.default_hint_class
    )
  end

  def file_tag_or_text
    template.link_to(@object.send(method).filename, @object.send(method))
  end
end
