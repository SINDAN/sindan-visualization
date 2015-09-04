require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    @user = User.new(
      name: 'name',
      email: 'user@example.com',
      password: 'user@example.com',
    )
  end

  it "is valid with valid attributes" do
    expect(@user).to be_valid
  end
end
