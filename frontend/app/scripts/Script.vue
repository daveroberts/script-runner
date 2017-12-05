<template>
  <div>
    <h1>{{script.name}}</h1>
    <button @click="toggle_edit()">flipmode</button>
    <form>
      <table class="table">
        <tbody>
          <tr>
            <th>Name</th>
            <td>
              <input v-if="editing" type="text" v-model="script.name" />
              <span v-else>{{script.name}}</span>
            </td>
          </tr>
          <tr>
            <th>Description</th>
            <td>
              <input v-if="editing" type="text" v-model="script.description" />
              <span v-else>{{script.description}}</span>
            </td>
          </tr>
        </tbody>
        <tbody v-for="trigger in script.triggers">
          <tr>
            <th>Type</th>
            <td>
              <select v-if="editing" v-model="trigger.type">
                <option v-for="type in trigger_types" v-bind:value="type">{{type}}</option>
              </select>
              <span v-else>{{trigger.type}}</span>
            </td>
          </tr>
          <tr v-if="trigger.type == 'CRON'">
            <th>Every</th>
            <td>
              <span v-if="editing"><input type="text" v-model="trigger.every" /> minutes</span>
              <span v-else>{{trigger.every}} minutes</span>
            </td>
          </tr>
          <tr v-if="trigger.type == 'QUEUE'">
            <th>Queue Name</th>
            <td>
              <input v-if="editing" type="text" v-model="trigger.queue_name" />
              <span v-else>{{trigger.queue_name}}</span>
            </td>
          </tr>
        </tbody>
        <tbody>
          <tr>
            <th>Code</th>
            <td>
              <div v-if="editing" class="code_editor">
                <codemirror v-model="script.code" :options="editorOptions"></codemirror>
              </div>
              <div v-else>{{script.code}}</div>
            </td>
          </tr>
          <tr>
            <th></th>
            <td><button>Save</button></td>
          </tr>
        </tbody>
      </table>
    </form>
    <div v-if="!editing">
      <h2>Last 10 Runs</h2>
      <table>
        <thead>
          <tr>
            <th>Run</th>
            <th>Status</th>
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
</template>
<script>
import state from '../state/state.js'
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
    toggle_edit(){ this.editing = !this.editing }
  }
}
</script>
<style lang="less" scoped>
@import '../styles/variables.less';
</style>
