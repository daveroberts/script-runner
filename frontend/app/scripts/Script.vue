<template>
  <div>
    <h1>{{script.name}}</h1>
    <div>{{script.description}}</div>
    <div v-for="trigger in script.triggers">
      <span v-if="trigger.every">Cron: Every {{trigger.every}} minutes</span>
      <span v-if="trigger.queue_name">Queue: On item sent to {{trigger.queue_name}}</span>
    </div>
    <pre>{{script.code}}</pre>
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
</template>
<script>
import state from '../state/state.js'
import initial from '../state/initial.js'
export default {
  data: function(){
    return {
      state: state,
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
  }
}
</script>
<style lang="less" scoped>
@import '../styles/variables.less';
</style>
