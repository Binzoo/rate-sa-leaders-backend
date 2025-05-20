Rails.application.routes.draw do
  namespace :web do
    namespace :api do
      namespace :v1 do
        resources :politicians, only: [:index, :show], param: :slug do
          member do
            post :upvote
            post :downvote
            
          end
          collection do
            get :getsixpolitican
           
          end
        end
      end    
    end  
  end

  namespace :admin do
    namespace :api do
      namespace :v1 do
        resources :politicians, param: :slug do
          collection do
            get :dashboardStats
          end
        end
        post '/login', to: 'admins#login'
      end    
    end  
  end

end
