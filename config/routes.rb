Rails.application.routes.draw do
  unless Rails.env.production?
    get 'tests' => 'test_squad#tests', format: false, as: false
  end
end
