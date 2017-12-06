<template>
  <div>
    <div v-if="script">
      <h1>{{script.name}}</h1>
      <button type="button" v-if="!editing" class="btn" @click="edit()"><i class="fa fa-pencil"></i> Edit</button>
      <form @submit.prevent="save()">
        <table>
          <tbody>
            <tr class="form_row">
              <th class="form_label">Name</th>
              <td>
                <input v-if="editing" type="text" v-model="script.name" />
                <span v-else>{{script.name}}</span>
              </td>
            </tr>
            <tr class="form_row">
              <th class="form_label">Description</th>
              <td>
                <input v-if="editing" type="text" v-model="script.description" />
                <span v-else>{{script.description}}</span>
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
                <span v-if="editing">
                  <select v-model="trigger.type">
                    <option v-for="type in trigger_types" v-bind:value="type">{{type}}</option>
                  </select>
                  <button type="button" class="btn btn-small btn-danger" @click="remove_trigger(trigger)"><i class="fa fa-minus-circle" aria-hidden="true"></i> remove</button>
                </span>
                <span v-else>{{trigger.type}}</span>
              </td>
            </tr>
            <tr class="form_row" v-if="trigger.type == 'CRON'">
              <th class="form_label">Every</th>
              <td>
                <span v-if="editing"><input type="number" style="width: 4em;" v-model="trigger.every" /> minutes</span>
                <span v-else>{{trigger.every}} minutes</span>
              </td>
            </tr>
            <tr class="form_row" v-if="trigger.type == 'QUEUE'">
              <th class="form_label">Queue Name</th>
              <td>
                <input v-if="editing" type="text" v-model="trigger.queue_name" />
                <span v-else>{{trigger.queue_name}}</span>
              </td>
            </tr>
          </tbody>
          <tbody v-if="editing">
            <tr class="form_row">
              <th></th>
              <td><button type="button" class="btn btn-small" @click="add_trigger()"><i class="fa fa-plus" aria-hidden="true"></i> Add trigger</button></td>
            </tr>
          </tbody>
          <tbody>
            <tr class="form_row">
              <th class="form_label">Code</th>
              <td>
                <div v-if="editing" class="code_editor">
                  <codemirror v-model="script.code" :options="editorOptions"></codemirror>
                </div>
                <div v-else>
                  <pre v-highlightjs="script.code"><code class="javascript"></code></pre>
                </div>
              </td>
            </tr>
            <tr v-if="editing" class="form_row">
              <th></th>
              <td>
                <button type="submit" class="btn btn-main" @click.prevent="save()"> <i class="fa fa-floppy-o" aria-hidden="true"></i> Save</button>
                <button type="button" class="btn" @click="cancel()"> <i class="fa fa-ban" aria-hidden="true"></i> Cancel</button>
              </td>
            </tr>
          </tbody>
        </table>
      </form>
      <div v-if="!editing">
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
    </div>
  </div>
</template>
<script>
import state from '../state/state.js'
import * as senate from '../state'
import initial from '../state/initial.js'
export default {
  data: function(){
    return {
      state: state,
      editing: false,
      trigger_types: ['CRON', 'QUEUE'],
      editorOptions: {
        tabSize: 2,
        mode: 'text/javascript',
        lineNumbers: true,
        line: true,
      }
    }
  },
  computed: {
    script(){ return state.current.script },
    runs(){ return state.current.runs },
  },
  created: function(){
    if (!state.current.script || state.current.script.id != this.$route.params.id) {
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
    edit(){ this.editing = true },
    cancel(){ this.editing = false },
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
        this.editing = false
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
    }
  }
}
</script>
<style lang="less" scoped>
@import '../styles/variables.less';
</style>
