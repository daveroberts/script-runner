<template>
  <div>
    <h1>{{queue}}</h1>
    <div v-if="!items">
      Loading...
    </div>
    <div v-else>
      <table class="table">
        <thead>
          <tr>
            <th>Key</th>
            <th>Item</th>
            <th>State</th>
            <th>Added At</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="item in items">
            <td><pre>{{item.item_key}}</pre></td>
            <td><pre>{{item.item}}</pre></td>
            <td>{{item.state}}</td>
            <td>{{item.created_at}}</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>
<script>
import Vue from 'vue'
import state from '../state/state.js'
import * as senate from '../state'
import initial from '../state/initial.js'
export default {
  data: function(){
    return {
      state: state,
    }
  },
  computed: {
    queue(){ return state.queues.current },
    items(){
      if (state.queues.data == null){ return null }
      var idx = state.queues.data.findIndex(queue => queue.name == state.queues.current)
      if (idx == -1){ return null }
      return state.queues.data[idx].items
    }
  },
  created: function(){
    state.queues.current = this.$route.params.name
    fetch(`/api/queues/${this.$route.params.name}`).then((res)=>{
      if (res.ok){ return res.json() }
    }).then((items)=>{
      if (state.queues.data == null){ state.queues.data = [] }
      var idx = state.queues.data.findIndex(q=> q.name == state.queues.current )
      if (idx == -1){
        state.queues.data.push({name: state.queues.current, items: items})
      } else {
        var queue = state.queues.data[idx]
        queue.items = items
        Vue.set(state.queues.data, idx, queue)
      }
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
</style>
