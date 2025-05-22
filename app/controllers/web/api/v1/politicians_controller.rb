module Web
  module Api
    module V1
      class PoliticiansController < ApplicationController
        before_action :find_politican, only: [:show, :upvote, :downvote]

        def index 
          if params[:query].present?
            q = params[:query].downcase
            @politicians = Politician.where(
              "LOWER(full_name) LIKE :q OR LOWER(party) LIKE :q OR LOWER(position) LIKE :q OR LOWER(region) LIKE :q",
              q: "%#{q}%"
            )
          else
            @politicians = Politician.order(full_name: :asc)
          end

          render json: @politicians, status: :ok 
        end


        def getsixpolitican
          @politician = Politician.limit(6)
          render json: @politician, status: :ok
        end

        
        def show
          if @politician
            render json: @politician, status: :ok
          else
            render json: { error: "Politician not found" }, status: :not_found
          end
        end

        def upvote
          ip = real_ip
          vote = Vote.find_by(politician_id: @politician.id, ip_address: ip)
          if vote
            if vote.vote_type == "down"
              @politician.upvotes = @politician.upvotes - 1
              vote.vote_type = "up"
              vote.save!
              render json: { message: "You have already voted, we are chaning your vote from Unlike to Like."}, status: :ok
              return
            end
            render json: { error: "You’ve already voted from this Politician previoulsy." }, status: :ok
            return
          end
          if @politician
            @politician.upvotes = @politician.upvotes + 1
            @politician.total_votes = @politician.total_votes + 1
            @politician.save!
            render json: { message: "Upvoted successfully" }, status: :ok
            Vote.create!(politician_id: @politician.id, ip_address: ip, vote_type: "up")
          else
            render json: { error: "Politician not found" }, status: :not_found
          end
        end

        def downvote
            ip = real_ip
            vote = Vote.find_by(politician_id: @politician.id, ip_address: ip)
            if vote
              if vote.vote_type == "up"
                @politician.downvotes = @politician.downvotes - 1
                vote.vote_type = "down"
                vote.save!
                render json: { message: "You have already voted, we are chaning your vote from Like to UnLike."}, status: :ok
                return
              end
              render json: { error: "You’ve already voted from this Politician previoulsy." }, status: :ok
              return
            end
            if @politician
             @politician.downvotes = @politician.downvotes + 1
             @politician.total_votes = @politician.total_votes + 1
             @politician.save!
            Vote.create!(politician_id: @politician.id, ip_address: ip, vote_type: "down")
             render json: { message: "Downvoted successfully" }, status: :ok
            else
             render json: { error: "Politician not found" }, status: :not_found
            end
        end

        private
        def find_politican
          @politician = Politician.find_by(slug: params[:slug])
        end

        def real_ip
          request.headers['X-Forwarded-For']&.split(',')&.first || request.remote_ip
        end

      end    
    end
  end
end
