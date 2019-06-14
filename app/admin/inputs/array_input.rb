# frozen_string_literal: true

class ArrayInput
  include Formtastic::Inputs::Base

  def to_html
    input_wrapping do
      inputs = []

      @object[method].each_with_index do |v, _x|
        next if v.blank?

        inputs << array_input_html(v)
      end

      label_html <<
        template.content_tag(:div, class: 'input-group--array') do
          inputs.join.html_safe << array_input_html('', false)
        end
    end
  end

  private

  def array_input_html(value, remove = true)
    button = remove ? remove_button : add_button
    template.content_tag(:div, class: 'input-group--array__item') do
      # return button if value.blank?
      template.text_field_tag("#{object_name}[#{method}][]", value, id: nil) << button
    end
  end

  def remove_button
    template.content_tag(:button,
                         template.fa_icon('minus-circle'),
                         class: 'array-action--remove js-remove-from-array-input',
                         type: 'button')
  end

  def add_button
    template.content_tag(:button,
                         template.fa_icon('plus-circle'),
                         class: 'array-action--add js-add-to-array-input',
                         type: 'button')
  end
end
