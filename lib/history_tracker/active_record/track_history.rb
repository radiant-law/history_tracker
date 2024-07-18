module HistoryTracker
  module ActiveRecord
    module TrackHistory
      extend ActiveSupport::Concern

      module ClassMethods
        # Track history on the given model.
        #
        # @param [ Hash ] options
        #
        # Available options:
        # only:
        # except:
        # changes_method:
        # on:
        # class_name:

        def track_history(options = {})
          # don't allow multiple calls
          return if self.included_modules.include?(HistoryTracker::ActiveRecord::InstanceMethods)

          default_options      = {
              on:             [:create, :update, :destroy],
              changes_method: :changes,
              belonging:      nil,
              eav_hashes:     nil,
              habtm_ids:      nil
          }
          options              = default_options.merge(options)

          # make :only and :except are array
          options[:only]       = [options[:only]] unless options[:only].is_a? Array
          options[:except]     = [options[:except]] unless options[:except].is_a? Array
          options[:eav_hashes] = [options[:eav_hashes]] unless options[:eav_hashes].is_a? Array
          options[:habtm_ids]  = [options[:habtm_ids]] unless options[:habtm_ids].is_a? Array

          # makes these methods available on class/instance
          delegate :history_trackable_options, :tracked_fields, :non_tracked_fields,
                   :history_tracker_class, :track_history?, to: 'self.class'

          has_many :histories, class_name: 'HistoryTracker::AuditHistory', as: :historyable, dependent: :destroy
          has_many :history_tracks, class_name: 'HistoryTracker::AuditHistory', as: :belonging, dependent: :destroy

          after_create :track_create if options[:on].include?(:create)
          before_update :track_update if options[:on].include?(:update)
          before_destroy :track_destroy if options[:on].include?(:destroy)

          extend HistoryTracker::ActiveRecord::ClassMethods
          include HistoryTracker::ActiveRecord::InstanceMethods

          HistoryTracker.trackable_class_options            ||= {}
          HistoryTracker.trackable_class_options[self.name] = options
        end
      end
    end
  end
end