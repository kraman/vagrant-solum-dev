require_relative "spec_helper"

describe "solum::python" do
  before { solum_stubs }
  describe "ubuntu" do
    before do
      @chef_run = ::ChefSpec::ChefRunner.new ::UBUNTU_OPTS
      @chef_run.converge "solum::python"
    end

    it "includes python recipe" do
      expect(@chef_run).to include_recipe 'python'
    end

  end
end
