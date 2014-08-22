require "rails_helper"

describe 'login page' do
  it 'require login at first time' do
    visit '/'
    expect(page).to have_text('로그인해주세요')
  end  
end