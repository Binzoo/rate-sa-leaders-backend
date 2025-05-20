module Admin
  module Api
    module V1
      class PoliticiansController < BaseController
        def index 
          @politicians = Politician.all
          render json: @politicians, status: :ok
        end
        
        def show
          @politician = Politician.find_by(slug: params[:slug])
          if @politician
            render json: @politician
          else
            render json: { error: "Politician not found" }, status: :not_found
          end
        end

        def create
          politician_data = params_politican
          if Politician.exists?(slug: politician_data[:slug])
            render json: { error: "Slug already exists" }, status: :conflict 
            return
          end
          @politician = Politician.new(params_politican)
          @politician.upvotes = 0
          @politician.downvotes = 0
          @politician.total_votes = 0
          if @politician.save
            render json: @politician, status: :ok
          else
            render json: { error: "Politician not created" }, status: :not_found
          end
        end

        def update
          @politician = Politician.find_by(slug: params[:slug])
          if @politician.nil?
            render json: { error: "Politician not found" }, status: :not_found
            return
          end
          politician_data = params_politican

          if @politician.slug != politician_data[:slug]
             if Politician.exists?(slug: politician_data[:slug])
                render json: { error: "Slug already exists" }, status: :conflict 
              return
             end
          end

          if @politician.update(params_politican)
            render json: {
              message: "Politician updated successfully",
              politician: @politician
            }, status: :ok
          else
            render json: {
              errors: "Failed to update politician",
              details:  @politician.errors.full_messages
            }, status: :unprocessable_entity
          end
        end

        def destroy
          @politician = Politician.find_by(slug: params[:slug])
          if @politician.nil?
            render json: { error: "Politician not found" }, status: :not_found
            return
          end

          if @politician.destroy!
            render json: {
              message: "Politician deleted successfully."
            }, status: :ok
          else
            render json: {
              message: "There was a problem deleted politician successfully."
            }, status: :ok
          end
        end

        def dashboardStats
          total_polotician = Politician.count
          total_votes = Politician.sum(:total_votes)
          most_popular_party = Politician.group(:party).order('SUM(total_votes) DESC').limit(1).pluck(:party).first

          render json: {
            totalPoliticians: total_polotician,
            totalVotes: total_votes,
            mostPopularParty: most_popular_party
          }, status: :ok

        end
      
        private
        def params_politican
          params.require(:politician).permit(:full_name, :position, :party, :region, :about, :image_url, :slug)
        end
      end    
    end
  end
end
