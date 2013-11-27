require_relative "spec_helper"

describe "solum::user" do
  before { solum_stubs }
  describe "ubuntu" do
    before do
      @chef_run = ::ChefSpec::ChefRunner.new ::UBUNTU_OPTS
      @chef_run.converge "solum::user"
    end

    it "includes sudo recipe" do
      expect(@chef_run).to include_recipe 'sudo'
    end

    it "creates solum user" do
      expect(@chef_run).to create_user('solum')
    end

  end
end
