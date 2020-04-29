# typed: true
# frozen_string_literal: false

require 'frontman/app'
require 'frontman/config'

module Frontman
  class Context
    def method_missing(method_id, *arguments, &block)
      # We forward everything to App
      Frontman::App.instance.public_send(method_id, *arguments, &block)
    end

    def respond_to_missing?(method_name, _include_private = false)
      # We forward everything to App
      Frontman::App.instance.respond_to?(method_name)
    end

    def wrap_layout(layout)
      layout_dir = Frontman::Config.get(:layout_dir, fallback: 'views/layouts')
      layout_path = File.join(layout_dir, layout)

      # Haml is not designed to do handle wrap_layout properly
      # so we need to hack the buffer of haml that is set
      # inside the context by haml
      save_buffer

      # We don't save the content of the yield, it will be saved in the buffer
      yield

      # The buffer now contains the content of the yield
      content = load_buffer

      # Restore the buffer so the rendering of the file can continue
      restore_buffer

      Resource.from_path(layout_path, nil, false).render(content)
    end

    def partial(template, data = {})
      partial_dir = Frontman::Config.get(
        :layout_dir, fallback: 'views/partials'
      )
      r = Resource.from_path(File.join(partial_dir, template), nil, false)
      r.render(nil, data)
    end

    def content_for(key, content = nil)
      # Haml is not designed to do handle content_for properly
      # so we need to hack the buffer of haml that is set
      # inside the context by haml
      save_buffer

      content ||= ''

      if block_given?
        # We don't save the content of the yield, it will be saved in the buffer
        yield

        # The buffer now contains the content of the yield
        content = load_buffer
      end

      # Restore the buffer so the rendering of the file can continue
      restore_buffer

      # We store the the content block inside the current page
      # because we don't know which renderer/layout/template will need it
      current_page.content_blocks[key.to_sym] = content unless current_page.nil?
    end

    def content_for?(key)
      current_page.content_blocks.key?(key.to_sym)
    end

    def yield_content(key, *_args)
      current_page.content_blocks[key.to_sym]
    end

    def render_page(page, options = {})
      # We force not to render any layout
      options[:layout] = nil
      options[:ignore_page] = true

      # We don't need to cache here since it already done in the render function
      # of the resource
      page.render(nil, options)
    end

    def render_current_page(options = {})
      render_page(current_page, options)
    end

    def get_binding(&content)
      binding { content }
    end

    private

    def save_buffer
      haml_locals = instance_variable_get(:@_haml_locals)

      if haml_locals
        # save buffer
        @buffer = haml_locals[:_hamlout].buffer
        # empty the buffer so we can capture everything from the new render
        haml_locals[:_hamlout].buffer = ''
      else
        # save buffer
        @buffer = instance_variable_get(:@_erbout)
        # empty the buffer so we can capture everything from the new render
        instance_variable_set(:@_erbout, '')
      end
    end

    def restore_buffer
      haml_locals = instance_variable_get(:@_haml_locals)

      if haml_locals
        haml_locals[:_hamlout].buffer = @buffer
      else
        instance_variable_set(:@_erbout, @buffer)
      end
    end

    def load_buffer
      haml_locals = instance_variable_get(:@_haml_locals)

      if haml_locals
        haml_locals[:_hamlout].buffer
      else
        instance_variable_get(:@_erbout)
      end
    end
  end
end
