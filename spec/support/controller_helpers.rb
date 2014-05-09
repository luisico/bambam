module Controller
  module TestHelpers
    def stub_sign_in
      user = double('user')
      request.env['warden'].stub :authenticate! => user
      controller.stub :current_user => user
    end
  end
end
