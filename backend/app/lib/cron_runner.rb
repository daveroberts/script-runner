class CronRunner
  def self.run
    # Get all active scripts with active CRON triggers
    scripts = Script.all.select{|s|s[:active]&&s[:triggers].any?{|t|t[:active]&&t[:type]=='CRON'}}
    scripts.each do |script|
      triggers = script[:triggers].select{|t|t[:active]&&t[:type]=='CRON'}
      triggers.each do |trigger|
        # If the script hasn't been triggered in the last X minutes, run it
        next if script[:last_run] && ((Time.now - script[:last_run])/60) < trigger[:every]
        script_run = Script.run_code(script[:code], nil, script[:extensions], script[:id], trigger[:id])
      end
    end
  end
end
