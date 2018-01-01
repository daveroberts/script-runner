<template>
  <div>
    <a class="btn" href="/#/scripts/new" @click="new_script()"><i class="fa fa-file-text-o"></i> New Script</a>
    <h1>Scripts</h1>
    <table class="table">
      <thead>
        <tr>
          <th>Name</th>
          <th>Triggered</th>
          <th style="text-align: center;">Active</th>
          <th>Last Run</th>
        </tr>
      </thead>
      <tbody class="script" v-for="script in scripts">
        <tr>
          <td><a :href="'/#/scripts/'+script.id" @click="select(script)" class="script_link">{{script.name}}</a></td>
          <td>
            <span v-if="script.cron_every">every {{script.cron_every}} minutes</span>
            <span v-if="script.queue_name">queue `{{script.queue_name}}`</span>
            <span v-if="script.http_method">HTTP endpoint: {{script.http_method}} `{{script.http_endpoint}}`</span>
          </td>
          <td style="text-align: center;"><span v-if="script.active"><i class="success fa fa-check" aria-hidden="true"></i></span></td>
          <td>{{pretty_date(script.last_run)}}</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>
<script>
import initial from '../state/initial.js'
import state from '../state/state.js'
import Helpers from '../helpers.js'
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
    fetch(`/api/scripts/`, {
         credentials: 'include'
    }).then((res)=>{
      if (res.ok){ return res.json() }
    }).then((scripts)=>{
      state.list = scripts
    }).catch((err)=>{
      console.log(err)
    })
  },
  mixins: [Helpers],
  methods: {
    select(script){
      state.current = JSON.parse(JSON.stringify(initial.current))
      state.current.script = script
    },
    new_script(){
      state.current = JSON.parse(JSON.stringify(initial.current))
    }
  }
}
</script>
<style lang="less" scoped>
@import '../styles/variables.less';
.key{ font-weight: bold; }
.script_link{ text-decoration: none; }
</style>
