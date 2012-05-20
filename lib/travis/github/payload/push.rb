require 'gh'

module Travis
  module Github
    module Payload
      class Push
        attr_reader :payload, :gh

        def initialize(payload)
          @payload = payload
          @gh = GH.load(payload)
        end

        def accept?
          true
        end

        def repository
          @repository ||= {
            :name        => gh['repository']['name'],
            :description => gh['repository']['description'],
            :url         => gh['repository']['_links']['html']['href'],
            :owner_name  => gh['repository']['owner']['login'],
            :owner_email => gh['repository']['owner']['email'],
            :owner_type  => gh['repository']['owner']['type'],
            :private     => !!gh['repository']['private']
          }
        end

        def owner
          @owner ||= {
            :type  => gh['repository']['owner']['type'],
            :login => gh['repository']['owner']['login']
          }
        end

        def request
          @request ||= {
            :payload => payload,
          }
        end

        def commit
          unless defined?(@commit)
            if gh['commits'].length == 1
              commit = gh['commits'].first
            else
              commit = gh['commits'].reverse.find do |commit|
                !(commit['message'].to_s =~ /\[ci(?: |:)([\w ]*)\]/i && $1.downcase == 'skip')
              end
              return nil unless commit
            end
            @commit = {
              :commit          => commit['sha'],
              :message         => commit['message'],
              :branch          => gh['ref'].split('/').last,
              :ref             => gh['ref'],
              :committed_at    => commit['date'],
              :committer_name  => commit['committer']['name'],
              :committer_email => commit['committer']['email'],
              :author_name     => commit['author']['name'],
              :author_email    => commit['author']['email'],
              :compare_url     => gh['compare']
            }
          end

          @commit
        end
      end
    end
  end
end
