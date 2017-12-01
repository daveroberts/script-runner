<template>
  <div>
    <h1>Saved Scripts</h1>
    {{scripts}}
    <div class="script" v-for="script in scripts">
      <div><span class="key">Name:</span> {{script.name}}</div>
      <div><span class="key">Description:</span> {{script.description}}</div>
      <div><span class="key">Active:</span> {{script.active}}</div>
      <div><span class="key">Created:</span> {{script.created_at}}</div>
      <div><span class="key">Triggers:</span></div>
      <div v-for="trigger in script.triggers">
        {{trigger}}
      </div>
      <div class="code">{{script.script}}</div>
    </div>
  </div>
</template>
<script>
import state from '../state/state.js'
export default {
  data: function(){
    return {
      state: state,
    }
  },
  computed: {
    scripts(){ return state.scripts.saved }
  },
  created: function(){
    fetch(`/api/scripts/`).then((res)=>{
      if (res.ok){ return res.json() }
    }).then((scripts)=>{
      state.scripts.saved = scripts
    }).catch((err)=>{
      console.log(err)
    })
  },
  methods: {
  }
}
</script>
<style lang="less" scoped>
@import '../styles/variables.less';
.script{ border: 1px solid @background; margin: 1em; padding: 1em; line-height: 1.3em; }
.key{ font-weight: bold; }
.code{ white-space: pre; font-family: monospace; border: 1px solid #777; margin: 1em; padding: 1em; }
</style>
