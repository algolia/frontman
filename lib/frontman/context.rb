# typed: true
# frozen_string_literal: false

require 'frontman/app'
require 'frontman/concerns/forward_calls_to_app'
require 'frontman/config'
require 'sorbet-runtime'

module Frontman
  class Context
    extend T::Sig
    include Frontman::ForwardCallsToApp

    sig { params(layout: String).returns(String) }
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

    sig do
      params(key: T.any(String, Symbol), content: T.untyped)
        .returns(T.untyped)
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
      current_page = Frontman::App.instance.current_page
      current_page.content_blocks[key.to_sym] = content unless current_page.nil?
    end

    sig { params(key: T.any(String, Symbol)).returns(T::Boolean) }
    def content_for?(key)
      Frontman::App.instance.current_page.content_blocks.key?(key.to_sym)
    end

    sig do
      params(key: T.any(String, Symbol), _args: T.untyped).returns(T.untyped)
    end
    def yield_content(key, *_args)
      Frontman::App.instance.current_page.content_blocks[key.to_sym]
    end

    sig do
      params(content: T.untyped).returns(T.untyped)
    end
    def get_binding(&content)
      binding { content }
    end

    private

    sig { void }
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

    sig { void }
    def restore_buffer
      haml_locals = instance_variable_get(:@_haml_locals)

      if haml_locals
        haml_locals[:_hamlout].buffer = @buffer
      else
        instance_variable_set(:@_erbout, @buffer)
      end
    end

    sig { returns(T.untyped) }
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
