# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::JSONS do
  let(:subject) { Rouge::Lexers::JSONS.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.jsons'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'application/schema+json'
    end
  end
end
