<template>
  <div>
    <h1>Script Runner</h1>
    <textarea v-model="state.scripts.current"></textarea>
    <button class="btn" @click="run()">Do it</button>
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
  },
  created: function(){
  },
  methods: {
    "run": function(){
      fetch(`/api/run`, {
        method: 'POST',
        body: state.scripts.current
      }).then(res => {
        console.log(res)
        if (res.ok){ return res.json() }
      }).then(output => {
        state.scripts.history.push(output)
        console.log(output)
      }).catch(err => {
        console.log(err)
      })
    }
  }
}
</script>
<style>
</style>
