require_relative "spec_helper"

describe "solum::database" do
  before { solum_stubs }
  describe "ubuntu" do
    before do
      @chef_run = ::ChefSpec::ChefRunner.new ::UBUNTU_OPTS do |n|
        n.set["mysql"] = {
          "server_debian_password" => "server-debian-password",
          "server_root_password" => "server-root-password",
          "server_repl_password" => "server-repl-password"
        }
        n.set["solum"]["db"] = {
          "name" => "solum",
          "user" => "solum",
          "pass" => "solum"
        }
      end
      @chef_run.converge "solum::database"
    end

    it "includes mysql recipes" do
      ['database', 'mysql::ruby', 'mysql::client','mysql::server'].each do |recipe|
        expect(@chef_run).to include_recipe recipe
      end
    end

    describe "lwrps" do
      before do
        @connection = {
          :host => "localhost",
          :username => "root",
          :password => "server-root-password"
        }
      end

      it "creates the solum database" do
        resource = @chef_run.find_resource(
          "database",
          "create solum database"
        ).to_hash
        expect(resource).to include(
          :connection    => @connection,
          :database_name => 'solum',
          :action        => [:create]
        )
      end

      it 'grants privs to solum user@%' do
        resource = @chef_run.find_resource(
          'database_user',
          'grant privs to solum user@%'
        ).to_hash
        expect(resource).to include(
          :connection     => @connection,
          :database_name  => 'solum',
          :username       => 'solum',
          :username       => 'solum',
          :host           => '%',
          :privileges     => [:select,:update,:insert],
          :action         => [:grant]
        )
      end

      it 'grants privs to solum user@localhost' do
        resource = @chef_run.find_resource(
          'database_user',
          'grant privs to solum user@localhost'
        ).to_hash
        expect(resource).to include(
          :connection     => @connection,
          :database_name  => 'solum',
          :username       => 'solum',
          :username       => 'solum',
          :host           => 'localhost',
          :privileges     => [:select,:update,:insert],
          :action         => [:grant]
        )
      end

    end

  end
end


