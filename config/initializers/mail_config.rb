begin
  ActionMailer::Base.default 'Content-Transfer-Encoding' => 'quoted-printable'

  if Rails.env.production?
    ActionMailer::Base.smtp_settings = {
    address: 'smtp.mandrillapp.com',
    port: '587',
    authentication: :plain,
    user_name: Configuration[:MANDRILL_USERNAME],
    password: Configuration[:MANDRILL_APIKEY],
    domain: 'crowdfunded.micropasts.org'
    }
    ActionMailer::Base.delivery_method = :smtp
  end
rescue
  nil
end
