require 'rails_helper'

RSpec.describe Account, type: :model do
  it { should belong_to(:user) }
  it { should have_many(:movements).dependent(:destroy) }

  it { should validate_presence_of(:CLABE).on(:update) }
  it { should validate_uniqueness_of(:CLABE).on(:update) }
end
