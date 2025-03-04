require 'rails_helper'

RSpec.describe Project, type: :model do
  it "is valid with a valid name" do
    project = build(:project)
    expect(project).to be_valid
  end

  it "is invalid without an email" do
    project = build(:project, name: nil)
    expect(project).not_to be_valid
  end
end
