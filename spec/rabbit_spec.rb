require_relative 'spec_helper'

describe 'solum::rabbit' do
  before { solum_stubs }
  describe 'ubuntu' do
    before do
      @chef_run = ::ChefSpec::ChefRunner.new ::UBUNTU_OPTS do |n|
        n.set['solum']['rabbit'] = {
          'admin_user'  => 'admin',
          'admin_pass'  => 'admin',
          'user'        => 'solum',
          'pass'        => 'solum',
          'vhosts'      => ['solum']
        }
      end
      @chef_run.converge 'solum::rabbit'
    end

    it 'includes rabbitmq recipe::default' do
      expect(@chef_run).to include_recipe 'rabbitmq::default'
    end

     it 'includes rabbitmq recipe::plugin_management' do
      expect(@chef_run).to include_recipe 'rabbitmq::plugin_management'
    end

     it 'includes rabbitmq recipe::mgmt_console' do
      expect(@chef_run).to include_recipe 'rabbitmq::mgmt_console'
    end

     it 'includes rabbitmq recipe::user_management' do
      expect(@chef_run).to include_recipe 'rabbitmq::user_management'
    end

    describe 'lwrps' do

      it 'adds rabbit admin user' do
        resource = @chef_run.find_resource(
          'rabbitmq_user',
          'add rabbit admin user'
        ).to_hash
        expect(resource).to include(
          :user     => 'admin',
          :password => 'admin',
          :action   => [:add]
        )
      end

      it 'sets rabbit admin user to admin' do
        resource = @chef_run.find_resource(
          'rabbitmq_user',
          'set rabbit admin user to admin'
        ).to_hash
        expect(resource).to include(
          :user     => 'admin',
          :tag      => 'administrator',
          :action   => [:set_tags]
        )
      end

      it 'adds solum rabbit user' do
        resource = @chef_run.find_resource(
          'rabbitmq_user',
          'add solum rabbit user'
        ).to_hash
        expect(resource).to include(
          :user     => 'solum',
          :password => 'solum',
          :action   => [:add]
        )
      end

      ['solum'].each do |vhost|
        it "sets perms for rabbit user for #{vhost}" do
          resource = @chef_run.find_resource(
            'rabbitmq_user',
            "set perms for rabbit user for #{vhost}"
          ).to_hash
          expect(resource).to include(
            :user         => 'solum',
            :vhost        => vhost,
            :permissions  => '.* .* .*',
            :action       => [:set_permissions]
          )
        end
      end

    end
  end
end

