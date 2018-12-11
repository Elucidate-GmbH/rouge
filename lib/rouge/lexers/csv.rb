# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    load_lexer 'awk.rb'

    class CSV < Awk
      tag 'csv'
      title "csv"
      desc 'The CSV Language'
      mimetypes 'text/csv'
      filenames '*.csv'
    end
  end
end
