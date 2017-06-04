require 'test_helper'

class ConfigTest < ActiveSupport::TestCase
  def test_mail_config
    config = Mail.retriever_method.settings
    assert_equal( "pop_server", config[:address] )
    assert_equal( "pop_user", config[:user_name] )
    assert_equal( "pop_pass", config[:password] )
  end
end
