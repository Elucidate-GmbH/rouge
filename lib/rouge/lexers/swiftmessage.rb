# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Swiftmessage < RegexLexer
      tag 'Swiftmessage'
      aliases 'swiftmessage', 'Swift-message'
      filenames '*.swift'
      mimetypes 'text/swiftmessage'

      title "SwiftMessage"
      desc 'The Swift fin Messages, for MT### and MX###'

      def self.keywords
        @keywords ||= Set.new %w(
          for in of while break return continue switch when then if else
          throw try catch finally new delete typeof instanceof super
          extends this class by CHK MAC TNG
        )
      end

      def self.constants
        @constants ||= Set.new %w(
          USD EUR 
        )
      end

      def self.builtins
        @builtins ||= Set.new %w(
          Array Boolean Date Error Function Math netscape Number Object
          Packages RegExp String sun decodeURI decodeURIComponent
          encodeURI encodeURIComponent eval isFinite isNaN parseFloat
          parseInt document window CHK MAC TNG
        )
      end

      id = /[$a-zA-Z_][a-zA-Z0-9_]*/

      state :comments_and_whitespace do
        rule /\s+/m, Text
        rule /###\s*\n.*?###/m, Comment::Multiline
        rule /#.*$/, Comment::Single
      end

      state :multiline_regex do
        # this order is important, so that #{ isn't interpreted
        # as a comment
        mixin :has_interpolation
        mixin :comments_and_whitespace

        rule %r(///([gim]+\b|\B)), Str::Regex, :pop!
        rule %r(/), Str::Regex
        rule %r([^/#]+), Str::Regex
      end

      state :slash_starts_regex do
        mixin :comments_and_whitespace
        rule %r(///) do
          token Str::Regex
          goto :multiline_regex
        end

        rule %r(
          /(\\.|[^\[/\\\n]|\[(\\.|[^\]\\\n])*\])+/ # a regex
          ([gim]+\b|\B)
        )x, Str::Regex, :pop!

        rule(//) { pop! }
      end

      state :root do
        rule(%r(^(?=\s|/|<!--))) { push :slash_starts_regex }
        mixin :comments_and_whitespace
        rule %r(
          [+][+]|--|~|&&|\band\b|\bor\b|\bis\b|\bisnt\b|\bnot\b|[?]|:|=|
          [|][|]|\\(?=\n)|(<<|>>>?|==?|!=?|[-<>+*`%&|^/])=?
        )x, Operator, :slash_starts_regex

        rule /[-=]>/, Name::Function

        rule /(@)([ \t]*)(#{id})/ do
          groups Name::Variable::Instance, Text, Name::Attribute
          push :slash_starts_regex
        end


        rule /#{id}(?=\s*:)/, Name::Attribute, :slash_starts_regex

        rule /#{id}/ do |m|
          if self.class.keywords.include? m[0]
            token Keyword
          elsif self.class.constants.include? m[0]
            token Name::Constant
          elsif self.class.builtins.include? m[0]
            token Name::Builtin
          else
            token Name::Other
          end

          push :slash_starts_regex
        end

        rule /[{(\[;,]/, Punctuation, :slash_starts_regex
        rule /[})\].]/, Punctuation

        rule /\d+[.]\d+([eE]\d+)?[fd]?/, Num::Float
        rule /0x[0-9a-fA-F]+/, Num::Hex
        rule /\d+/, Num::Integer
        rule /"""/, Str, :tdqs
        rule /'''/, Str, :tsqs
        rule /"/, Str, :dqs
        rule /'/, Str, :sqs
      end

    end
  end
end
