<template>
  <div>
    <queue-browser queue_name="testing"></queue-browser>
    <div v-if="script">
      <h1 v-if="script.name">{{script.name}}</h1>
      <h1 v-else>Code</h1>
      <div class="code_editor">
        <codemirror v-model="script.code" :options="editorOptions"></codemirror>
      </div>
      <div v-if="script.id">
        <button type="submit" class="btn btn-small" @click.prevent="save()"> <i class="fa fa-floppy-o" aria-hidden="true"></i> Save Changes</button>
      </div>
      <h2>Run Script</h2>
      <div class="fancy_checkbox">
        <input id="input_send" type="checkbox" v-model="state.current.input.send" />
        <label for="input_send"></label>
      </div>
      <label for="input_send">Send Input</label>
      <div v-if="state.current.input.send" class="code_editor">
        <codemirror v-model="state.current.input.payload" :options="editorOptions"></codemirror>
      </div>
      <div style="margin: 1em 0;">
        <button class="btn" @click="run()"><i class="fa fa-code" aria-hidden="true"></i> Run</button>
      </div>
      <div v-if="!script.id && !save_for_later" style="margin-top: 3em;">
        <button class="btn" @click="set_save_for_later()"><i class="fa fa-save" aria-hidden="true"></i> Save Script</button>
      </div>
      <div v-if="runs.length">
        <h2>Last 10 Runs</h2>
        <table class="table">
          <thead>
            <tr>
              <th>Run</th>
              <th>Output</th>
            </tr>
          </thead>
          <tbody v-for="run in runs">
            <tr>
              <td>{{run.run_at}}</td>
              <td>{{run.output}}</td>
            </tr>
          </tbody>
        </table>
      </div>
      <div v-if="script.id || save_for_later">
        <h2>Script Details</h2>
        <form @submit.prevent="save()">
          <table>
            <tbody>
              <tr class="form_row">
                <th class="form_label">Name</th>
                <td>
                  <input type="text" v-model="script.name" />
                </td>
              </tr>
              <tr class="form_row">
                <th class="form_label">Description</th>
                <td>
                  <input type="text" v-model="script.description" />
                </td>
              </tr>
            </tbody>
            <tbody class="form_section" v-for="(trigger, index) in script.triggers">
              <tr class="form_row" v-if="script.triggers.length > 1">
                <th colspan="2" style="text-align: left;">Trigger #{{index+1}}</th>
              </tr>
              <tr class="form_row">
                <th class="form_label">Type</th>
                <td>
                  <span>
                    <select v-model="trigger.type">
                      <option v-for="type in trigger_types" v-bind:value="type">{{type}}</option>
                    </select>
                    <button type="button" class="btn btn-small btn-danger" @click="remove_trigger(trigger)"><i class="fa fa-minus-circle" aria-hidden="true"></i> remove</button>
                  </span>
                </td>
              </tr>
              <tr class="form_row" v-if="trigger.type == 'CRON'">
                <th class="form_label">Every</th>
                <td>
                  <span><input type="number" style="width: 4em;" v-model="trigger.every" /> minutes</span>
                </td>
              </tr>
              <tr class="form_row" v-if="trigger.type == 'QUEUE'">
                <th class="form_label">Queue Name</th>
                <td>
                  <input type="text" v-model="trigger.queue_name" />
                </td>
              </tr>
            </tbody>
            <tbody>
              <tr class="form_row">
                <th></th>
                <td><button type="button" class="btn btn-small" @click="add_trigger()"><i class="fa fa-plus" aria-hidden="true"></i> Add trigger</button></td>
              </tr>
            </tbody>
            <tbody>
              <tr class="form_row">
                <th></th>
                <td>
                  <button type="submit" class="btn btn-main" @click.prevent="save()"> <i class="fa fa-floppy-o" aria-hidden="true"></i> Save</button>
                </td>
              </tr>
            </tbody>
          </table>
        </form>
      </div>
    </div>
  </div>
</template>
<script>
import state from '../state/state.js'
import * as senate from '../state'
import initial from '../state/initial.js'
import QueueBrowser from '../queues/Browser.vue'
export default {
  data: function(){
    return {
      state: state,
      save_for_later: false,
      trigger_types: ['CRON', 'QUEUE'],
      editorOptions: {
        tabSize: 2,
        mode: 'text/javascript',
        lineNumbers: true,
        line: true,
      }
    }
  },
  components: { QueueBrowser },
  computed: {
    script(){ return state.current.script },
    runs(){ return state.current.runs }
  },
  created: function(){
    if (this.$route.params.id == 'new'){
      state.current = JSON.parse(JSON.stringify(initial.current))
    }
    if (!state.current.script || (state.current.script.id != this.$route.params.id) && this.$route.params.id != 'new') {
      state.current = JSON.parse(JSON.stringify(initial.current))
      fetch(`/api/scripts/${this.$route.params.id}`).then((res)=>{
        if (res.ok){ return res.json() }
      }).then((script)=>{
        state.current.script = script
      }).catch((err)=>{
        console.log(err)
      })
    }
    if (!state.current.runs) {
      fetch(`/api/last_10_runs/${this.$route.params.id}`).then((res)=>{
        if (res.ok){ return res.json() }
      }).then((runs)=>{
        state.current.runs = runs
      }).catch((err)=>{
        console.log(err)
      })
    }
  },
  methods: {
    set_save_for_later(){ this.save_for_later=true; },
    save(){
      fetch(`/api/scripts`, {
        method: 'POST',
        credentials: 'include',
        body: JSON.stringify(state.current.script)
      }).then(res => {
        if (res.ok){ return res.json() }
        console.log(res)
        throw new Error("not OK")
      }).then( data => {
        console.log(data)
        senate.flash("Script saved")
        state.current.script = data.script
        this.$router.replace(`/scripts/${state.current.script.id}`)
      }).catch(err => {
        console.log(err)
      })
    },
    add_trigger(){
      state.current.script.triggers.push(senate.new_trigger())
    },
    remove_trigger(trigger){
      var idx = state.current.script.triggers.indexOf(trigger)
      if (idx > -1){ state.current.script.triggers.splice(idx, 1) }
    },
    run(){
      fetch(`/api/run`, {
        method: 'POST',
        credentials: 'include',
        body: JSON.stringify(state.current)
      }).then(res => {
        return res.json()
      }).then(output => {
        state.current.runs.unshift(output)
      }).catch(err => {
        console.log(err)
      })
    }
  }
}
</script>
<style lang="less" scoped>
@import '../styles/variables.less';
</style>
