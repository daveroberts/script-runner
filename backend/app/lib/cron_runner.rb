class CronRunner
  def self.run
    loop do
      script = Script.next_cron_script
      if !script
        puts "#{Time.now} No more cron scripts need to be run right now"
        puts "#{Time.now} Sleeping for 30 seconds"
        sleep 1*3
        next
      end
      puts "#{Time.now} Running #{script[:id]} : #{script[:name]}"
      script_run = Script.run_code(script[:code], nil, nil, script[:id])
      if script_run[:error]
        puts "#{Time.now} Finished with error. script: #{script[:id]} script_run_id #{script_run[:id]} running time (seconds): #{script_run[:milliseconds_running]/1000}"
      else
        puts "#{Time.now} Finished successfully. script: #{script[:id]} script_run_id #{script_run[:id]} running time (seconds): #{script_run[:milliseconds_running]}"
      end
      Script.mark_cron_as_run(script[:id])
    end
  end
end
