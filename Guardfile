# Guard의 매치 패턴 선언
guard :minitest, spring: "bin/rails test", all_on_start: false do
  watch(%r{^test/(.*)/?(.*)_test\.rb$})
  watch('test/test_helper.rb') { 'test' }
  watch('config/routes.rb')    { integration_tests }
  watch(%r{^app/models/(.*?)\.rb$}) do |matches|
    "test/models/#{matches[1]}_test.rb"
  end
  watch(%r{^app/controllers/(.*?)_controller\.rb$}) do |matches|
    resource_tests(matches[1])
  end
  watch(%r{^app/views/([^/]*?)/.*\.html\.erb$}) do |matches|
    [ "test/controllers/#{matches[1]}_controller_test.rb" ] +
    integration_tests(matches[1])
  end
  watch(%r{^app/helpers/(.*?)_helper\.rb$}) do |matches|
    integration_tests(matches[1])
  end
  watch('app/views/layouts/application.html.erb') do
    'test/integration/site_layout_test.rb'
  end
  watch('app/helpers/sessions_helper.rb') do
    integration_tests << 'test/helpers/sessions_helper_test.rb'
  end
  watch('app/controllers/sessions_controller.rb') do
    [ 'test/controllers/sessions_controller_test.rb',
     'test/integration/users_login_test.rb' ]
  end
  watch('app/controllers/account_activations_controller.rb') do
    'test/integration/users_signup_test.rb'
  end
  watch(%r{app/views/users/*}) do
    resource_tests('users') +
    [ 'test/integration/microposts_interface_test.rb' ]
  end
end

# 주어진 리소스에 대응하는 테스트 코드를 리턴
def integration_tests(resource = :all)
  if resource == :all
    Dir["test/integration/*"]  else
    Dir["test/integration/#{resource}_*.rb"]
  end
end

# 주어진 리소스에 대응하는 컨트롤러 테스트를 리턴
def controller_test(resource)
  "test/controllers/#{resource}_controller_test.rb"
end

# 주어진 리소스에 대응하는 모든 테스트를 리턴
def resource_tests(resource)
  integration_tests(resource) << controller_test(resource)
end
