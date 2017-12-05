<template>
  <div>
    <h1>Saved Scripts</h1>
    <div class="script" v-for="script in scripts">
      <a href="#" :href="'/#/scripts/'+script.id" @click="select(script)" class="script_link">
        <div><span class="key">Name:</span> {{script.name}}</div>
        <div><span class="key">Description:</span> {{script.description}}</div>
        <div><span class="key">Active:</span> {{script.active}}</div>
        <div><span class="key">Created:</span> {{script.created_at}}</div>
        <div><span class="key">Triggers:</span></div>
        <div v-for="trigger in script.triggers">
          {{trigger.name}}
          {{trigger.every}}
          {{trigger.queue_name}}
        </div>
        <div class="code">{{script.code}}</div>
      </a>
    </div>
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
.code{ white-space: pre; font-family: monospace; border: 1px solid #777; margin: 1em; padding: 1em; }
</style>
