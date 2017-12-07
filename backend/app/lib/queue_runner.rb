class QueueRunner
  def self.run
    scripts = Script.all
    items = QueueItem.new_items
    items.each do |item|
      processing_scripts = scripts.select{|s|s[:active]&&s[:triggers].any?{|t|t[:active]&&t[:type]=='QUEUE'&&t[:queue_name]==item[:queue_name]}}
      next if processing_scripts.none?
      result = QueueItem.lock_for_processing(item[:id])
      next if result == 0
      processing_scripts.each do |script|
        trigger = script[:triggers].detect{|t|t[:active]&&t[:type]=='QUEUE'&&t[:queue_name]==item[:queue_name]}
        script_run = Script.run_code(script[:code], item[:item], script[:id], trigger[:id], item[:queue_name], item[:item_key])
      end
      result = QueueItem.finish_processing(item[:id])
    end
  end
end
