require 'test_helper'

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @category = Category.create(name: 'Sports')
    @admin_user = User.create(username: 'johndoe', email: 'johndoe@example.com',
                              password: 'password', password_confirmation: 'password',
                              admin: true)
  end

  test 'should get index' do
    get categories_url
    assert_response :success
  end

  test 'should get new' do
    login_as(@admin_user)

    get new_category_url
    assert_response :success
  end

  test 'should not get new if not admin' do
    get new_category_url

    assert_redirected_to categories_url
  end

  test 'should create category' do
    login_as(@admin_user)

    assert_difference('Category.count', 1) do
      post categories_url, params: { category: { name: 'Travel' } }
    end

    assert_redirected_to category_url(Category.last)
  end

  test 'should not create category if not admin' do
    assert_no_difference('Category.count') do
      post categories_url, params: { category: { name: 'Travel' } }
    end

    assert_redirected_to categories_url
  end

  test 'should show category' do
    get category_url(@category)
    assert_response :success
  end

  # test 'should get edit' do
  #   get edit_category_url(@category)
  #   assert_response :success
  # end

  # test 'should update category' do
  #   patch category_url(@category), params: { category: {  } }
  #   assert_redirected_to category_url(@category)
  # end

  # test 'should destroy category' do
  #   assert_difference('Category.count', -1) do
  #     delete category_url(@category)
  #   end

  #   assert_redirected_to categories_url
  # end
end
