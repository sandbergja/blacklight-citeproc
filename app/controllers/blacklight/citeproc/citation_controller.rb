require 'bibtex'
require 'citeproc'
require 'csl/styles'

module Blacklight::Citeproc
  class BadConfigError < StandardError
  end

  class CitationController < ApplicationController
    include Blacklight::Searchable

    def initialize
      @processors = []
      @citations = []

      throw BadConfigError, 'Catalog controller needs a config.citeproc section' unless blacklight_config.citeproc
      @config = blacklight_config.citeproc
      @config[:styles].each do |style|
        @processors << ::CiteProc::Processor.new(format: 'html', style: style)
      end
    end

    def print_single
      _, document = search_service.fetch(params[:id])
      bibtex = ::BibTeX::Bibliography.new
      bibtex << document.export_as(:bibtex)

      @processors.each do |processor|
        processor.import bibtex.to_citeproc
	citation = processor.render(:bibliography, id: params[:id]).first.tr('{}', '')
	@citations << {citation: citation.html_safe, label: processor.options[:style]}
      end
      render layout: false
    end

  end
end
