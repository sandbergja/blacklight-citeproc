Blacklight::Citeproc::Engine.routes.draw do
  get '/catalog/:id/citation' => 'blacklight/citeproc/citation#print_single'
end
