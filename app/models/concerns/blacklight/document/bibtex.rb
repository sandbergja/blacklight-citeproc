# This is a document extension meant to be mixed into a
# Blacklight::Solr::Document class, such as SolrDocument. It provides support
# for creating bibtex format from a Solr document.
#
# This extension would normally be registered using
# Blacklight::Solr::Document#use_extension.  eg:
#
# SolrDocument.use_extension( Blacklight::Document::BibTeX )
#
# This extension also expects some data from blacklight_config (set in Catalog Controller)

require 'bibtex'

module Blacklight::Document::Bibtex
  def self.extended(document)
    Blacklight::Document::Bibtex.register_export_formats(document)
  end

  def self.register_export_formats(document)
    document.will_export_as(:bibtex, "application/x-bibtex")
  end

  def export_as_bibtex
    config = ::CatalogController.blacklight_config.citeproc

    entry = ::BibTeX::Entry.new
    entry.type = :book
    entry.key = self.id
    entry.title = self.first config[:fields][:title]
    multiple_valued_fields = %i{author editor}
    multiple_valued_fields.each do |field|
      entry.send("#{field}=", self.fetch(config[:fields][field])) if self.has? config[:fields][field]
    end

    single_valued_fields = %i{address annote booktitle chapter doi edition how_published institution
      journal key month note number organization pages publisher school series url volume year}
    single_valued_fields.each do |field|
      entry.send("#{field}=", self.first(config[:fields][field])) if self.has? config[:fields][field]
    end

    return entry
  end

  private
  def bibtex_type config
    config[:format][:mappings].each do |bibtex, solr|
      if solr.include? self.first config[:format][:field]
        return bibtex
      end
    end
    default_type = config[:format][:default_format] || :book
    return default_type
  end

end

