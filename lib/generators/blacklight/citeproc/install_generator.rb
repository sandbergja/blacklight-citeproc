require 'rails/generators'

module Blacklight::Citeproc
  class Install < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)
    def inject_routes
      inject_into_file 'config/routes.rb', after: /mount Blacklight::Engine.*$/ do
        "\n  mount Blacklight::Citeproc::Engine => '/'\n"
      end
    end
    def add_blacklight_citeproc_config
      insert_into_file "app/controllers/catalog_controller.rb", after: "  configure_blacklight do |config|\n" do
        <<-CONFIG
    config.citeproc = {
      #bibtex_field: 'bibtex_s' # Optional. If you are already indexing BibTeX into solr, this will be the preferred way to get bibliographic data
      fields: {
        address: 'published_ssm',
        author: 'author_tsim',
        edition: 'edition_tsim',
        publisher: 'publisher_tsim',
        title: 'title_tsim',
        url: 'url_tsim',
        year: 'pub_date_ssim'
      },
      styles: %w(apa chicago-fullnote-bibliography modern-language-association ieee council-of-science-editors),
      format: {
        field: 'format',
        default_format: :book,
        mappings: {
          book: ['Book', 'Musical Score', 'Ebook'],
          misc: ['Map/Globe', 'Non-musical Recording', 'Musical Recording', 'Image', 'Software/Data', 'Video/Film'],
        }
      }
    }
        CONFIG
      end
    end

    def add_marc_extension_to_solrdocument
      insert_into_file "app/models/solr_document.rb", :after => "include Blacklight::Solr::Document" do
        "\n  use_extension(Blacklight::Document::Bibtex)\n"
      end
    end
  end
end
