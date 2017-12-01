class CronRunner
  def self.run
    CronTrigger.all.each do |trigger|
      run = false
      run = true if !trigger[:last_run]
      if trigger[:last_run]
        minutes = (Time.now - trigger[:last_run]) / 60
        run = true if minutes > trigger[:every]
      end
      Script.pull_trigger(trigger[:id], trigger[:script_id], trigger[:script]) if run
    end
  end
end
