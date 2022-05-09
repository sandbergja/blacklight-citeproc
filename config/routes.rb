# frozen_string_literal: true

Blacklight::Citeproc::Engine.routes.draw do
  get '/catalog/:id/citation' => 'blacklight/citeproc/citation#print_single'
  get '/bookmarks/citation' => 'blacklight/citeproc/citation#print_bookmarks'
end
