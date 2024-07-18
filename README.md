# HistoryTracker


#### Installation

This gem depends on ActiveRecord 3.x/4.x and Mongoid 3.x/4x.

```ruby
gem 'history_tracker', :path => 'vendor/history_tracker'
rails g history_tracker:install
```

#### Usages

HistoryTracker is simple to use. Just call `track_history` to a model to track changes on every create, update, and destroy.

```ruby
# app/models/listing.rb
class Listing < ActiveRecord::Base

  track_history   class_name:     'ListingHistoryTracker'          # specify the tracker class name, default is the newly mongoid class with "HistoryTracker" suffix
                  only:           [:name],                         # track only the specified fields
                  except:         [],                              # track all fields except the specified fields
                  on:             [:create, :update, :destroy],    # by default, it tracks all events
                  changes_method: :changes,                        # alternate changes method
                  belonging:      nil                              # it's to track parent reference
end
```

#### #current_user method name

By default, this gem will invoke `current_user` method and save its attributes on each change. However, you can change it by sets the `current_user_method` and `current_user_fields` using a Rails initializer.

```ruby
# config/initializers/history_tracker.rb
HistoryTracker.current_user_method = :authenticated_user
```
