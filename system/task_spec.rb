require 'rails_helper'

RSpec.describe do
  describe do
    it '1. The form should be generated so that images are registered against the `profile_image` column.' do
      visit new_user_path
      expect(find('input[name="user[profile_image]"]')).to be_visible
    end
  end
  describe do
    before do
      visit new_user_path
      fill_in 'user_name', with: 'sample'
      fill_in 'user_email', with: 'user@gmail.com'
      fill_in 'user_password', with: 'password'
      fill_in 'user_password_confirmation', with: 'password'
      attach_file 'user[profile_image]', "#{Rails.root}/spec/fixtures/images/スクリーンショット 2021-01-08 18.33.25のコピー.png"
      find('input[type="submit"]').click
    end
    it '2. Ability to register a profile picture when registering an account.' do
      expect(page).to have_content 'Account was successfully created.'
    end
    it '3. Active Strage must be used.' do
      expect(User.last.profile_image.class).to eq ActiveStorage::Attached::One
    end
    it '4. When a user registers by selecting a profile image, the user is transferred to the detail screen and the profile image is displayed.' do
      expect(current_path).to eq user_path(User.last.id)
      # The entire path of the image changes depending on the time of posting, so we compared and tested a portion of the image that does not change.
      expect(page.find('img')['src']).to have_content '202021-01-08%2018.33.25%E3%81%AE%E3%82%B3%E3%83%94%E3%83%BC.png'
    end
  end
  describe do
    it '5. When a user registers without selecting a profile image, the user should be transferred to the detail screen without generating an error.' do
      visit new_user_path
      fill_in 'user_name', with: 'sample'
      fill_in 'user_email', with: 'user@gmail.com'
      fill_in 'user_password', with: 'password'
      fill_in 'user_password_confirmation', with: 'password'
      find('input[type="submit"]').click
      expect(current_path).to eq user_path(User.last.id)
    end
  end
  describe do
    it '6. Use Action Mailer to send email to that user when they register for an account.' do
      visit new_user_path
      fill_in 'user_name', with: 'sample'
      fill_in 'user_email', with: 'user@gmail.com'
      fill_in 'user_password', with: 'password'
      fill_in 'user_password_confirmation', with: 'password'
      attach_file 'user[profile_image]', "#{Rails.root}/spec/fixtures/images/スクリーンショット 2021-01-08 18.33.25のコピー.png"
      perform_enqueued_jobs do
        find('input[type="submit"]').click
      end
      email = ActionMailer::Base.deliveries.last
      expect(email.to).to eq ['user@gmail.com']
    end
  end
  describe do
    it "7. The email text specified in the requirement must have been sent." do
      visit new_user_path
      fill_in 'user_name', with: 'sample'
      fill_in 'user_email', with: 'user@gmail.com'
      fill_in 'user_password', with: 'password'
      fill_in 'user_password_confirmation', with: 'password'
      attach_file 'user[profile_image]', "#{Rails.root}/spec/fixtures/images/スクリーンショット 2021-01-08 18.33.25のコピー.png"
      perform_enqueued_jobs do
        find('input[type="submit"]').click
      end
      email = ActionMailer::Base.deliveries.last
      expect(email.from).to eq ["admin@example.com"]
      expect(email.subject).to eq "Registration complete"
      expect(email.decoded).to include "sample"
      expect(email.decoded).to include "Account registration has been completed."
    end
  end
  describe do
    it '8. Implementing Acitve Job and sending mails asynchronously using `deliever_later` method.' do
      visit new_user_path
      fill_in 'user_name', with: 'sample'
      fill_in 'user_email', with: 'user@gmail.com'
      fill_in 'user_password', with: 'password'
      fill_in 'user_password_confirmation', with: 'password'
      attach_file 'user[profile_image]', "#{Rails.root}/spec/fixtures/images/スクリーンショット 2021-01-08 18.33.25のコピー.png"
      expect { find('input[type="submit"]').click }.to change { enqueued_jobs.size }.by(2)
    end
  end
end
