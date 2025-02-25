require 'rails_helper'

RSpec.describe MapImage, type: :model do
  before(:each) do
    @map_image = FactoryBot.build(:map_image, name: "Map Name")
  end

  it "is valid with valid attributes" do
    expect(@map_image).to be_valid
  end

  it "is not valid with same another name" do
    @map_image.save

    @map_image_dup = FactoryBot.build(:map_image, name: "Map Name")

    expect(@map_image_dup).not_to be_valid
  end

  it "is valid with empty name" do
    @map_image.name = ''
    @map_image.save

    @map_image_dup = FactoryBot.build(:map_image, name: "")

    expect(@map_image_dup).to be_valid
  end
end
