# Generated via
#  `rails generate hyrax:work PagedResource`
require 'rails_helper'

RSpec.describe Hyrax::PagedResourcePresenter do

  subject { described_class.new(double, double) }

  context "When the resource has extracted text indexed for searching" do
    it "responds to search_service" do
      expect(subject).to respond_to(:search_service)
    end
  end
end
