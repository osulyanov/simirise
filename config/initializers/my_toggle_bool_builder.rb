# frozen_string_literal: true

require 'activeadmin_addons/support/custom_builder.rb'

module ActiveAdminAddons
  class MyToggleBoolBuilder < CustomBuilder
    def render
      # raise ArgumentError, 'Block should not be used in toggle bool columns' if block
      return if conditional_eval_hide?

      context.div class: 'toggle-bool-switches-container' do
        context.span toggle
      end
    end

    def toggle
      toggle_classes = 'toggle-bool-switch'
      toggle_classes += ' on' if data
      toggle_classes += ' notify-success' if options[:success_message]

      context.span(
        '',
        id: "toggle-#{class_name}-#{model.id}-#{attribute}",
        class: toggle_classes,
        'data-model' => class_name,
        'data-object_id' => model.id,
        'data-field' => attribute,
        'data-value' => data,
        'data-url' => context.auto_url_for(model) + '/toggle',
        'data-success_message' => options[:success_message]
      )
    end

    def conditional_eval_hide?
      %i[if unless].any? do |cond|
        if options[cond]
          raise ArgumentError, "'#{cond}' option should be a proc" unless options[cond].is_a?(Proc)

          result = options[cond].call(model)
          cond == :if ? !result : result
        end
      end
    end
  end
end

ActiveAdminAddons::MyToggleBoolBuilder.create_view_methods
