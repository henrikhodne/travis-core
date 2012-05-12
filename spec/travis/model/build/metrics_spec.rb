require 'spec_helper'
require 'core_ext/module/include'

class BuildMetricsMock
  include do
    attr_accessor :state

    def start(data = {})
      self.state = :started
    end

    def started_at
      Time.now
    end

    def request
      stub('request', :created_at => Time.now - 60)
    end
  end

  include Build::Metrics
end

describe Build::Metrics do
  let(:build) { BuildMetricsMock.new }

  it 'measures the time it takes from creating the request until starting the build' do
    build.expects(:meter).with('travis.builds.wait_until_started', 60)
    build.start(:started_at => Time.now)
  end
end
