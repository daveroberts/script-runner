import state from './state.js'
import initial from './initial.js'

export const flash = (msg, type = 'success') => {
  var id = Math.floor((Math.random() * 9999) + 1)
  state.alerts.push({id: id, msg: msg, show: true, type: type})
  setTimeout(()=>{
    var idx = state.alerts.findIndex((a)=>a.id==id)
    state.alerts[idx].show = false
  }, 3000)
  setTimeout(()=>{
    var idx = state.alerts.findIndex((a)=>a.id==id)
    state.alerts.splice(idx, 1)
  }, 3500 )
}

export const new_script = () => JSON.parse(JSON.stringify(initial.blank.script))
export const new_trigger = () => JSON.parse(JSON.stringify(initial.blank.trigger))
