class QueueRunner
  def self.run
    triggers = QueueTrigger.all
    items = QueueItem.new_items
    items.each do |item|
      next if triggers.has_key? item[:queue_name]
      result = QueueItem.process(item[:id])
      next if result == 0
      triggers[item[:queue_name]].each do |trigger|
        Script.pull_trigger(trigger[:id], trigger[:script_id], trigger[:script], item[:item])
      end
    end
  end
end
