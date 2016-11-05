# React production
if Rails.env.produciton?
  Rails.application.config.react.variant = :production
end
