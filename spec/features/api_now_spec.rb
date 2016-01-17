require 'rails_helper'

# describe 'api/now' do
#   it 'fail to load data' do
#     visit '/api/now'

#     expect(page).to have_text('sign in')
#   end

#   it 'can load json after login' do
#     # login process
#     user = create(:user)

#     visit '/'
#     within('form') do
#       fill_in 'login_id', with: user.login_id
#       fill_in 'password', with: user.password
#     end
#     click_button 'Sign in'

#     # check
#     visit 'api/now'
#     expect(page).to have_text('fws')

#     # destroy user
#     user.destroy
#   end
# end
