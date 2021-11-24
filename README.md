# Blacklight::Citeproc
Swap in really accurate citations using a wide variety of citation styles to your Blacklight app.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'blacklight-citeproc'
```

And then execute:
```bash
$ bundle
```

And then run the install generator:
```bash
$ rails generate blacklight:citeproc:install
```

Go into your application's catalog controller, and set the correct fields:
```ruby
config.citeproc = {
  bibtex_field: 'bibtex_s' # Optional. If you are already indexing BibTeX into solr, this will be the preferred way to get bibliographic data
  # If no bibtex_field defined, or if it is not found in the solr document, use these fields instead:
  fields: {
    address: 'published_ssm',
    annote: 'annotation_tsim',
    author: 'author_tsim',
    booktitle: 'booktitle_tsim',
    chapter: 'chapter_tsim',
    doi: 'doi_tsim',
    edition: 'edition_tsim',
    editor: 'editor_tsim',
    how_published: 'how_published_tsim',
    institution: 'institution_tsim',
    journal: 'journal_tsim',
    key: 'id',
    month: 'month_tsim',
    note: 'note_tsim',
    number: 'number_tsim',
    organization: 'organization_tsim',
    pages: 'pages_tsim',
    publisher: 'publisher_tsim',
    school: 'school_tsim',
    series: 'series_tsim',
    title: 'title_tsim',
    type: 'type_tsim',
    url: 'url_tsim',
    volume: 'number_tsim',
    year: 'pub_date_ssim'
  },
  styles: %w(apa chicago-fullnote-bibliography modern-language-association ieee council-of-science-editors),
  format: {
    field: format
    default_format: :book
    mappings: {
      article: [],
      book: ['Book', 'Musical Score', 'Ebook'],
      booklet: [],
      conference: [],
      inbook: [],
      incollection: [],
      inproceedings: [],
      manual: [],
      mastersthesis: [],
      misc: ['Map/Globe', 'Non-musical Recording', 'Musical Recording', 'Image', 'Software/Data', 'Video/Film'],
     phdthesis: [],
     proceedings: [],
     techreport: [],
     unpublished: []
    }
  }
}
```

Finally, go into your locale files and make sure to add friendly versions of the citations styles you are using for each locale your app uses.

```yaml
en:
  blacklight:
    citeproc:
      styles:
        apa: APA 6th Edition
```

## Development

You can get a very simple blacklight app that uses this gem by running `docker-compose up -d`.