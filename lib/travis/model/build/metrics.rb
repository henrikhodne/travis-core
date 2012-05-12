class Build
  module Metrics
    def start(data = {})
      super
      meter 'travis.builds.wait_until_started', started_at - request.created_at
    end

    private

      def meter(name, time)
        # TODO what to use here? Metriks#timer propably won't work.
        # Metriks::Timer doesn't seem to have a way to inject a past
        # start_time?
      end
  end
end
