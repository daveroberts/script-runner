<template>
  <div>
    <h1>Saved Scripts</h1>
    <table class="table">
      <thead>
        <tr>
          <th>Name</th>
          <th>Description</th>
          <th>Last Run</th>
          <th>Active</th>
          <th>Created</th>
          <th>Triggered by</th>
        </tr>
      </thead>
      <tbody class="script" v-for="script in scripts">
        <td><a href="#" :href="'/#/scripts/'+script.id" @click="select(script)" class="script_link">{{script.name}}</a></td>
        <td>{{script.description}}</td>
        <td>last run</td>
        <td>{{script.active}}</td>
        <td>{{script.created_at}}</td>
        <td>
          <div v-for="trigger in script.triggers">
            <span v-if="trigger.type == 'CRON'">CRON {{trigger.every}}</span>
            <span v-if="trigger.type == 'QUEUE'">QUEUE {{trigger.queue_name}}</span>
          </div>
        </td>
      </tbody>
    </table>
  </div>
</template>
<script>
import initial from '../state/initial.js'
import state from '../state/state.js'
export default {
  data: function(){
    return {
      state: state,
    }
  },
  computed: {
    scripts(){ return state.list }
  },
  created: function(){
    fetch(`/api/scripts/`).then((res)=>{
      if (res.ok){ return res.json() }
    }).then((scripts)=>{
      state.list = scripts
    }).catch((err)=>{
      console.log(err)
    })
  },
  methods: {
    select(script){
      state.current = JSON.parse(JSON.stringify(initial.current))
      state.current.script = script
    }
  }
}
</script>
<style lang="less" scoped>
@import '../styles/variables.less';
.script{ border: 1px solid @background; margin: 1em; padding: 1em; line-height: 1.3em; }
.key{ font-weight: bold; }
</style>
