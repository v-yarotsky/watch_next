require 'minitest/autorun'
require 'webmock/minitest'
require 'vcr'
require 'watch_next'

VCR.configure do |config|
  config.cassette_library_dir = "test/fixtures/vcr_cassettes"
  config.hook_into :webmock
end

VCR_DEFAULTS = { record: :new_episodes }

class WatchNextTC < Minitest::Test
  def self.test(name, opts = {}, &block)
    define_method("xtest_#{name}") {} and return unless block

    if opts[:vcr]
      vcr_opts = VCR_DEFAULTS.merge(opts[:vcr])
      original_block = block
      block = proc do
        begin
          VCR.insert_cassette(vcr_opts)
          instance_eval(&original_block)
        ensure
          VCR.eject_cassette
        end
      end
    end

    define_method("test_#{name}", &block)
  end

  def self.xtest(name, opts = {}, &block)
    define_method("xtest_#{name}", &block)
  end
end

