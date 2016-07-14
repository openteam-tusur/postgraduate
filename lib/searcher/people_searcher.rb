module Searcher
  class PeopleSearcher < SearcherCarcas
    private

    def search
      Person.search do
        fulltext search_params.q if search_params.q
        without :id, search_params.ids if search_params.ids.present?
      end
    end
  end
end
