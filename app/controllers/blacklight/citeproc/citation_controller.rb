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
      @bibliographies = []

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

    def print_multiple ids
      _, documents = search_service.fetch(ids)
      bibtex = ::BibTeX::Bibliography.new
      documents.each do |document|
        bibtex << document.export_as(:bibtex)
      end

      @processors.each do |processor|
        processor.import bibtex.to_citeproc
	bibliography = processor.render(:bibliography)
	@citations << {citation: bibliography.html_safe, label: processor.options[:style]}
      end
      render :print_single, layout: false
    end

    def print_bookmarks
      bookmarks = token_or_current_or_guest_user.bookmarks
      bookmark_ids = bookmarks.collect { |b| b.document_id.to_s }
      print_multiple bookmark_ids
    end

  end
end
