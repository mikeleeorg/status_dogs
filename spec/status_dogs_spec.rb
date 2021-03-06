require 'spec_helper'

describe StatusDogs do

  include Rack::Test::Methods

  describe "dog responses" do

    let(:app) { StatusDogs.new(TestApp.new) }

    StatusDogs::DOGS.each do |code|

      it "displays dog for status #{code}" do
        get code.to_s
        last_response.should be_replaced_with_dog(code)
      end

    end

    it "won't replace response with a dog if there is no file for it" do
      get "600"
      last_response.should_not be_replaced_with_dog
    end

  end

  describe ":only" do

    let(:app) { StatusDogs.new(TestApp.new, :only => 200...300) }

    it "will replace response with a dog if status is within range" do
      get "206"
      last_response.should be_replaced_with_dog(206)
    end

    it "will not replace if there is no file for it" do
      get "299"
      last_response.should_not be_replaced_with_dog
    end

    it "will not replace if out of range" do
      get "404"
      last_response.should_not be_replaced_with_dog(404)
    end

  end

  describe ":except" do

    let(:app) { StatusDogs.new(TestApp.new, :except => 200...300) }

    it "will replace response with a dog if status is not in range" do
      get "404"
      last_response.should be_replaced_with_dog(404)
    end

    it "will not replace response with a dog if status is in range" do
      get "206"
      last_response.should_not be_replaced_with_dog(206)
    end

    it "won't replace dogs that are not known" do
      get "201"
      last_response.should_not be_replaced_with_dog
    end

  end

end
