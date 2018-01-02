class CronRunner
  def self.run
    loop do
      script = Script.next_cron_script
      if !script
        puts "#{Time.now} No cron scripts need to be run right now"
        puts "#{Time.now} Sleeping for 30 seconds"
        sleep 1*30
        next
      end
      puts "#{Time.now} Running #{script[:id]} : #{script[:name]}"
      script_run = Script.run_code(script[:code], nil, nil, script[:id])
      if script_run[:error]
        puts "#{Time.now} Finished with error. script_run_id #{script_run[:id]}"
      else
        puts "#{Time.now} Finished without error. script_run_id #{script_run[:id]}"
      end
      Script.mark_cron_as_run(script[:id])
    end
  end
end
