class QueueRunner
  def self.run
    loop do
      result = Script.run_queue_item
      if !result
        puts "#{Time.now} No more queue items found for processing"
        puts "#{Time.now} Sleeping for 60 seconds"
        sleep 1*60
        next
      end
    end
  end
end
