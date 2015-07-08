require 'spec_helper_acceptance'

describe 'compatibility' do
  let(:manifest) {
    <<-EOS
      class { 'compatibility': }
    EOS
  }

  describe 'puppet run' do
    it 'should work with no errors' do
      apply_manifest(manifest, :catch_failures => true)
    end

    it 'should be idempotent' do
      apply_manifest(manifest, :catch_changes => true)
    end
  end

  describe 'ruby' do
    it 'should have a version' do
      shell('ruby -v')
    end
  end

  describe 'facter' do
    it 'should have facts' do
      shell('facter -p')
    end
  end
end
