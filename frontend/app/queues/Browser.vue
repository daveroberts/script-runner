<template>
  <div>
    Queue Browser: {{queue_name}}
  </div>
</template>
<script>
import state from '../state/state.js'
export default {
  computed: {
  },
  props: ['queue_name'],
  created: function(){
  },
  data: function(){
    return {
      state: state
    }
  },
  methods: {
  }
}
</script>
