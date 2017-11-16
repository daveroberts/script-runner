<template>
  <div>
    <div>Info: {{message}}</div>
    <div>Count: {{count}} <button @click="increment">+</button><button @click="decrement">-</button></div>
    <div>History: {{ recentHistory }}</div>
  </div>
</template>
<script>
import { mapGetters, mapActions } from 'vuex'
export default {
  data: function(){
    return {
      message: 'Hello 世界!'
    }
  },
  computed: mapGetters([
    'count',
    'recentHistory'
  ]),
  methods: mapActions([
    'increment',
    'decrement'
  ])
}
</script>
