Rails.application.routes.draw do
  root "pages#home"
  resources :appointments, only: :create do
    collection do
      get :availability
    end
    resource :calendar, only: :show
  end
  get "appointment_responses/:token/confirm", to: "appointment_responses#confirm", as: :confirm_appointment_response
  get "appointment_responses/:token/cancel", to: "appointment_responses#cancel", as: :cancel_appointment_response
  get "appointment_responses/:token/reschedule", to: "appointment_responses#reschedule", as: :reschedule_appointment_response
  get "payments/:signed_id/checkout", to: "payments#show", as: :payment_checkout
  post "stripe/webhooks", to: "stripe_webhooks#create", as: :stripe_webhook
  post "appointments/preview", to: "appointments#preview", as: :appointment_preview
end
