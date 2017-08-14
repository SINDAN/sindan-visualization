class IgnoreErrorResult < ApplicationRecord
  validates_presence_of :ssid

  concerning :IgnoreLogTypes do
    included do
      serialize :ignore_log_types, Array
    end
  end
end
