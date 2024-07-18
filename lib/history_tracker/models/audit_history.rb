module HistoryTracker
  class AuditHistory < ::ActiveRecord::Base
    serialize :original, Hash
    serialize :modified, Hash
    serialize :changeset, Hash

    belongs_to :historyable, polymorphic: true
    belongs_to :modifier, class_name: 'User'

    validates :historyable_type, :historyable_id, :action, presence: true
    validates :action, inclusion: {in: %w(create update destroy)}

    scope :recent, -> { order(created_at: :desc) }
    scope :since, ->(time) { where(:created_at.gte => time) }
    scope :creates, -> { where(action: 'create') }
    scope :updates, -> { where(action: 'update') }
    scope :destroys, -> { where(action: 'destroy') }
    scope :of_belonging, ->(type, id) { where(belonging_type: type, belonging_id: id) }
    scope :of_type, ->(type) { where(historyable_type: type) }

    def self.recent_updated_since(time)
      recent.updated.since(time)
    end
  end
end