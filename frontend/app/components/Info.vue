<template>
  <div>
    <div>Info: {{message}}</div>
    <div>Count: {{count}} <button @click="increment">+</button><button @click="decrement">-</button></div>
  </div>
</template>
<script>
import state from '../state/state.js'
export default {
  data: function(){
    return {
      state: state,
      message: 'Hello 世界!'
    }
  },
  computed: {
    count: function(){ return state.count }
  },
  methods: {
    increment: function(){ state.count = state.count + 1 },
    decrement: function(){ state.count = state.count - 1 }
  }
}
</script>
