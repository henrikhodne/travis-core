module Travis
  module Services
    module Github
      class SyncUser < Base
        autoload :Organizations, 'travis/services/github/sync_user/organizations'
        autoload :Repositories,  'travis/services/github/sync_user/repositories'
        autoload :Repository,    'travis/services/github/sync_user/repository'

        def run
          syncing do
            Organizations.new(user).run
            Repositories.new(user).run
          end
        end

        def user
          current_user
        end

        private

          def syncing
            user.update_attribute(:is_syncing, true)
            result = yield
            user.update_attribute(:synced_at, Time.now)
            result
          rescue Timeout::Error, StandardError => e
            Travis::Exceptions.handle(e)
          ensure
            user.update_attribute(:is_syncing, false)
          end
      end
    end
  end
end
