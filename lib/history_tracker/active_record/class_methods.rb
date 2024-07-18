module HistoryTracker
  module ActiveRecord
    module ClassMethods

      def history_trackable_options
        @history_trackable_options ||= HistoryTracker.trackable_class_options[self.name]
      end

      def history_tracker_class
        return @history_tracker_class if @history_tracker_class
        @history_tracker_class = history_tracker_class_name.constantize
      end

      def history_tracker_class_name
        h = history_trackable_options
        h[:class_name].present? ? h[:class_name] : 'HistoryTracker::AuditHistory'
      end

      def tracked_fields
        @tracked_fields ||= (column_names - non_tracked_fields)
      end

      def non_tracked_fields
        return @non_tracked_fields if @non_tracked_fields

        # normalize :except fields to an array of database field strings
        h = history_trackable_options
        h[:only]    = h[:only].map { |field| database_field_name(field) }.compact.uniq
        h[:except]  = h[:except].map { |field| database_field_name(field) }.compact.uniq

        if h[:only].present?
          except = column_names - h[:only]
        else
          except = ignored_tracked_fields
          except |= h[:except] if h[:except].present?
        end

        @non_tracked_fields = except
      end

      # Returns the ignored tracked fields.
      # By default, it returns from the `HistoryTracker` module. Each class could override here.
      #
      # @return [ Array ] the list of fields that are ignored for trackings.
      def ignored_tracked_fields
        @ignored_tracked_fields ||= HistoryTracker.ignored_tracked_fields
      end

      # Whether or not the field should be tracked.
      #
      # @param [ String | Symbol ] field The name or alias of the field
      # @param [ String | Symbol ] action The optional action name (:create, :update, or :destroy)
      #
      # @return [ Boolean ] whether or not the field is tracked for the given action
      def tracked_field?(field, action = :update)
        tracked_fields_for_action(action).include? database_field_name(field)
      end

      # Retrieves the list of tracked fields for a given action.
      #
      # @param [ String | Symbol ] action The action name (:create, :update, or :destroy)
      #
      # @return [ Array < String > ] the list of tracked fields for the given action
      def tracked_fields_for_action(action)
        case action.to_sym
        when :destroy then tracked_fields + ignored_tracked_fields
        else tracked_fields
        end
      end

      # Returns true if the below conditions are met, ie: globally, per controller, per model.
      # This method is used to determine whether to track history or not.
      def track_history?
        HistoryTracker.enabled? && HistoryTracker.enabled_for_controller? && tracking_enabled?
      end

      # Returns true if this model is currently enabled for tracking history
      def tracking_enabled?
        Thread.current[track_history_flag] != false
      end

      def enable_tracking
        Thread.current[track_history_flag] = true
      end

      def disable_tracking
        Thread.current[track_history_flag] = false
      end

      def without_tracking(&_block)
        tracking_was_enabled = tracking_enabled?
        disable_tracking
        yield
      ensure
        enable_tracking if tracking_was_enabled
      end

      def track_history_flag
        "#{name}_history_trackable_enabled".to_sym
      end
    end
  end
end