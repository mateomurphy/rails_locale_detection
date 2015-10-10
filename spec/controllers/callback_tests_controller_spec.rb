require 'spec_helper'

describe CallbackTestsController, type: :controller do

  it "should automatically include the callback" do
    expect(subject.class.ancestors).to include(RailsLocaleDetection::ControllerMethods)
  end

  it "should correctly detect the user locale" do
    get :show

    expect(response.body).to eq('fr')
  end

end