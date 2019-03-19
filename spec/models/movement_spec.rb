require 'rails_helper'

RSpec.describe Movement, type: :model do
  it { should belong_to(:account) }

  it { should validate_presence_of(:amount) }
  it { should validate_presence_of(:reference) }
end
