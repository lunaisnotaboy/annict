# frozen_string_literal: true

module V4
  class TracksController < V4::ApplicationController
    before_action :authenticate_user!

    def show
      set_page_category PageCategory::TRACK

      @library_entry_entities = TrackPage::LibraryEntriesRepository.new(
        graphql_client: graphql_client(viewer: current_user)
      ).execute

      @slot_entities, @page_info_entity = TrackPage::SlotsRepository.new(
        graphql_client: graphql_client(viewer: current_user)
      ).execute(
        pagination: Annict::Pagination.new(before: params[:before], after: params[:after], per: 50)
      )
    end
  end
end