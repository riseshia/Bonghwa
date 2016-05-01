# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# initialize app
App.create!(
  home_name: 'Bonghwa',
  home_link: '/',
  app_name: 'Bonghwa',
  use_script: false,
  show_widget: false,
  widget_link: nil
)

# add Help to Link
Link.create!(link_to: '/help', name: 'Help')

# create admin account
User.create!(
  login_id: 'admin',
  password_digest: BCrypt::Password.create('admin'),
  name: '관리자',
  level: 999
)
