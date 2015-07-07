require 'spec_helper_acceptance'

describe 'compatibility' do
  let(:manifest) {
    <<-EOS
      class { 'compatibility': }
    EOS
  }

  describe 'running puppet code' do
    it 'should work with no errors' do
      # Run it twice and test for idempotency
      apply_manifest(manifest, :catch_failures => true)
      expect(apply_manifest(manifest, :catch_changes => true).exit_code).to be_zero
    end

    it 'can list files' do
      shell('/bin/ls /')
    end

    it 'ruby version' do
      shell('ruby -v')
    end

    it 'gem version' do
      shell('gem -v')
    end

    it 'facter version' do
      shell('facter -p')
    end
  end
end
