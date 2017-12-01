<template>
  <div>
    <h1>Saved Scripts</h1>
    {{ scripts }}
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
<style>
</style>
