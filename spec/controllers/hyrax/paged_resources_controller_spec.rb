# Generated via
#  `rails generate hyrax:work PagedResource`
require 'rails_helper'

RSpec.describe Hyrax::PagedResourcesController do
  include_examples("structure persister",
                   :paged_resource,
                   Hyrax::PagedResourcePresenter)
end
