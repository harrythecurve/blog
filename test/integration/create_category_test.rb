require "test_helper"

class CreateCategoryTest < ActionDispatch::IntegrationTest
  setup do
    @admin_user = User.create(username: 'johndoe', email: 'johndoe@example.com',
                              password: 'password', password_confirmation: 'password',
                              admin: true)
  end

  test "get new category form and create category" do
    # When logged in as admin
    login_as(@admin_user)

    # User goes to new category path
    get new_category_path
    assert_response :success

    # Creates a new category 'Sports'
    assert_difference 'Category.count', 1 do
      post categories_path, params: { category: { name: 'Sports' } }
      assert_response :redirect
    end
    follow_redirect!

    # Is redirected to the category page
    assert_response :success
    assert_match 'Sports', response.body
  end

  test "get new category form and reject invalid category submission" do
    # When logged in as admin
    login_as(@admin_user)

    # User goes to new category path
    get new_category_path
    assert_response :success

    # Submits a category with no name
    assert_no_difference 'Category.count' do
      post categories_path, params: { category: { name: ' ' } }
    end

    # Receives an error for the name being too short
    assert_select 'div.alert-danger'
    assert_select 'h4.alert-heading'
    assert_match 'Name is too short (minimum is 3 characters)', response.body

    # Submits a category with too long a name
    assert_no_difference 'Category.count' do
      post categories_path, params: { category: { name: 'a' * 21 } }
    end

    # Receives an error for the name being too long
    assert_select 'div.alert-danger'
    assert_select 'h4.alert-heading'
    assert_match 'Name is too long (maximum is 20 characters)', response.body
  end
end
