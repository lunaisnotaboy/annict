# frozen_string_literal: true

module Canary
  module Types
    module Objects
      class AnimeRecordType < Canary::Types::Objects::Base
        field :rating_overall, Canary::Types::Enums::RatingState, null: true, method: :rating_overall_state
        field :rating_animation, Canary::Types::Enums::RatingState, null: true, method: :rating_animation_state
        field :rating_music, Canary::Types::Enums::RatingState, null: true, method: :rating_music_state
        field :rating_story, Canary::Types::Enums::RatingState, null: true, method: :rating_story_state
        field :rating_character, Canary::Types::Enums::RatingState, null: true, method: :rating_character_state
      end
    end
  end
end
