module Web
  module Api
    module V1
      class EventsController < ApplicationController
        def index
          @event = Event.all
          render json: @event, status: :ok
        end

        def show
          @event = Event.find_by(slug: params[:slug])
          render json: @event, status: :ok
        end
      end
    end
  end
end