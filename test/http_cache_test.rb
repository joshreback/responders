require 'test_helper'
require 'pry'

class HttpCacheTest < ActionController::TestCase
  tests UsersController

  setup do
    @request.accept = 'application/json'
    ActionController::Base.perform_caching = true

    User.create(name: "First", updated_at: Time.utc(2009))
    User.create(name: "Second", updated_at: Time.utc(2008))
  end

  # First request: returns Last-Modified for client to use
  test 'responds with last modified using the latest timestamp' do
    get :index
    assert_equal Time.utc(2009).httpdate, @response.headers['Last-Modified']
    assert_match '"name":"First"', @response.body
    assert_equal 200, @response.status
  end

  # Subsequent request: resource has not been touched -- indicate it's still fresh
  test 'responds with not modified if request is still fresh' do  # 'fresh' meaning it has not been touched between requests
    @request.env['HTTP_IF_MODIFIED_SINCE'] = Time.utc(2009, 6).httpdate
    get :index
    assert_equal 304, @response.status
    assert @response.body.blank?
  end

  # Other subsequent request: resource has been modified since, return the resource
  test 'responds with last modified if request is not fresh' do
    @request.env['HTTP_IF_MODIFIED_SINCE'] = Time.utc(2008, 6).httpdate
    get :index
    assert_equal Time.utc(2009).httpdate, @response.headers['Last-Modified']
    assert_match '"name":"First"', @response.body
    assert_equal 200, @response.status
  end
end