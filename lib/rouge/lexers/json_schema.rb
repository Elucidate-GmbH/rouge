# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    load_lexer 'json.rb'

    class JSONS < JSON
      desc "JSON Schema"
      tag 'jsons'
      mimetypes 'application/schema+json'
      filenames '*.jsons'
    end
  end
end
