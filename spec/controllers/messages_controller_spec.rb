require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
    
    describe "Messages Index" do
        it "GET should require long in and be successful" do
          user = create(:user)
          sign_in user    
          get 'index'
          expect(response).to have_http_status(:success)
        end
      
        it "should handle an invalid message" do
          user = create(:user)
          sign_in user    
          get 'index'
          post 'index', params: { message: { content: "" } }, xhr: true
          expect(response).to have_http_status(:success)
        end
        
        it "POST should create a valid message" do
          user = create(:user)
          sign_in user    
          get 'index'
          post 'index', params: { message: { content: "Hello" } }, xhr: true
          expect(response).to have_http_status(:success)
        end
    end
end
