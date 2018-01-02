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
          <th>Last Run <a href="#" @click.prevent="refresh_last_run_times()"><i class="fa fa-refresh" aria-hidden="true"></i></a></th>
        </tr>
      </thead>
      <tbody class="script" v-for="script in scripts">
        <tr>
          <td><a :href="'/#/scripts/'+script.id" @click="select(script)" class="script_link">{{script.name}}</a></td>
          <td>
            <span v-if="script.trigger_cron">
              <span v-if="script.cron_every == 1">every minute</span>
              <span v-else>every {{script.cron_every}} minutes</span>
            </span>
            <span v-if="script.trigger_queue">queue `{{script.queue_name}}`</span>
            <span v-if="script.trigger_http">HTTP endpoint: {{script.http_method}} `{{script.http_endpoint}}`</span>
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
import * as senate from '../state'
import Helpers from '../helpers.js'
const loadScripts = () => {
  return new Promise((resolve, reject)=>{
    fetch(`/api/scripts/`, {
      credentials: 'include'
    }).then((res)=>{
      if (res.ok){ return res.json() }
    }).then((scripts)=>{
      state.list = scripts
      resolve()
    }).catch((err)=>{
      console.log(err)
      reject()
    })
  })
}
export default {
  data: function(){
    return {
      state: state
    }
  },
  computed: {
    scripts(){ return state.list }
  },
  created: function(){
    loadScripts()
  },
  mixins: [Helpers],
  methods: {
    select(script){
      state.current = JSON.parse(JSON.stringify(initial.current))
      state.current.script = script
    },
    new_script(){
      state.current = JSON.parse(JSON.stringify(initial.current))
    },
    refresh_last_run_times(){
      loadScripts()
        .then(() => senate.flash("Refreshed"))
        .catch(err => senate.flash("Could not refresh", "warning"))
    }
  }
}
</script>
<style lang="less" scoped>
@import '../styles/variables.less';
.key{ font-weight: bold; }
.script_link{ text-decoration: none; }
</style>
