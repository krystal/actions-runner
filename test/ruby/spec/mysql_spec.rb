require 'spec_helper'

require 'mysql2'

# test connecting to MySQL with mysql2
RSpec.describe 'MySQL connection' do
  let(:client) do
    Mysql2::Client.new(host: 'mariadb', username: 'root', password: 'root')
  end

  it 'can connect to MySQL' do
    expect { client }.not_to raise_error
  end
end
