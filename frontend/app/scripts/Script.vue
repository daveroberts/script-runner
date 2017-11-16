<template>
  <div>
    <h1>Script Runner</h1>
    <div v-if="error">{{ error }}</div>
    <textarea v-model="state.scripts.current"></textarea>
    <button class="btn" @click="run()">Do it</button>
    <div v-if="output">{{ output }}</div>
    <pre>{{ state.scripts }}</pre>
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
    error: function(){
      if (state.scripts.history.length == 0){ return null }
      const mrh = state.scripts.history[state.scripts.history.length - 1]
      if (mrh.status != 'error'){ return null }
      return mrh.error
    },
    output: function(){
      if (state.scripts.history.length == 0){ return null }
      const mrh = state.scripts.history[state.scripts.history.length - 1]
      if (mrh.status != 'ok'){ return null }
      return mrh.output
    }
  },
  created: function(){
  },
  methods: {
    "run": function(){
      fetch(`/api/run`, {
        method: 'POST',
        body: state.scripts.current
      }).then(res => {
        return res.json()
      }).then(output => {
        state.scripts.history.push(output)
      }).catch(err => {
        console.log(err)
      })
    }
  }
}
</script>
<style>
</style>
