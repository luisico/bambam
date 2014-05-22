#!/usr/bin/env puma

threads 0, 5

workers 0
on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end
preload_app!
