class QueueRunner
  def self.run
    loop do
      item = QueueItem.next
      if !item
        puts "#{Time.now} No more queue items found for processing"
        puts "#{Time.now} Sleeping for 60 seconds"
        sleep 1*60
        next
      end
      script = Script.for_queue(item[:queue_name])
      raise "No script found for queue item: #{item[:id]}" if !script
      puts "#{Time.now} Running script: #{script[:id]} : #{script[:name]} on item: #{item[:id]}"
      script_run = Script.run_code(script[:code], item[:item], nil, script[:id])
      if script_run[:error]
        result = QueueItem.error_processing(item[:id])
        puts "#{Time.now} Finished with error. script: #{script[:id]} script_run_id #{script_run[:id]} item: #{item[:id]} running time (seconds): #{script_run[:seconds_running]}"
      else
        result = QueueItem.finish_processing(item[:id])
        puts "#{Time.now} Finished without error. script: #{script[:id]} script_run_id #{script_run[:id]} item: #{item[:id]} running time (seconds): #{script_run[:seconds_running]}"
      end
    end
  end
end
