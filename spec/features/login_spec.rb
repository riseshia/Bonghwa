require 'rails_helper'

# describe 'login page' do
#   it 'require login at first time' do
#     visit '/'
#     expect(page).to have_text('로그인해주세요')
#   end

#   it 'login success' do
#     # login process
#     user = create(:user)
#     user.level = 1
#     user.save

#     visit '/'
#     within('form') do
#       fill_in 'login_id', with: user.login_id
#       fill_in 'password', with: user.password
#     end
#     click_button 'Sign in'

#     # check
#     expect(page).to have_button('Refresh')

#     # destroy user
#     user.destroy
#   end

#   it 'login fail with wrong password' do
#     # login process
#     user = create(:user)
#     user.level = 1
#     user.save

#     visit '/'
#     within('form') do
#       fill_in 'login_id', with: user.login_id
#       fill_in 'password', with: user.password + '1'
#     end
#     click_button 'Sign in'

#     # check
#     expect(page).to have_text('아이디/비밀번호가 올바르지 않습니다.')

#     # destroy user
#     user.destroy
#   end

#   it 'login fail with wrong id' do
#     # login process
#     user = create(:user)
#     user.level = 1
#     user.save

#     visit '/'
#     within('form') do
#       fill_in 'login_id', with: user.login_id + '1'
#       fill_in 'password', with: user.password
#     end
#     click_button 'Sign in'

#     # check
#     expect(page).to have_text('아이디/비밀번호가 올바르지 않습니다.')

#     # destroy user
#     user.destroy
#   end
# end
