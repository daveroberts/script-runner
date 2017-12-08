<template>
  <div>
    <h1>Queue: {{queue}}</h1>
    <div v-if="scripts">
      <h2>Scripts</h2>
      <div style="margin-bottom: 2em;">
        <ul v-if="scripts.length">
          <li v-for="script in scripts">
            <a :href="'/#/scripts/'+script.id" @click="select(script)" class="script_link">{{script.name}}</a>
          </li>
        </ul>
        <span style="font-style: italic">No scripts set to pick up from this queue</span>
      </div>
    </div>
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
        <tbody v-if="items.length">
          <tr v-for="item in items">
            <td><pre>{{item.item_key}}</pre></td>
            <td><pre>{{item.item}}</pre></td>
            <td>{{item.state}}</td>
            <td>{{item.created_at}}</td>
          </tr>
        </tbody>
        <tbody v-else>
          <tr>
            <td colspan="4" style="text-align: center; font-style: italic; padding: 2em;">This queue has no items</td>
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
    },
    scripts(){
      if (state.queues.data == null){ return null }
      var idx = state.queues.data.findIndex(queue => queue.name == state.queues.current)
      if (idx == -1){ return null }
      return state.queues.data[idx].scripts
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
        state.queues.data.push({name: state.queues.current, scripts: null, items: items})
      } else {
        var queue = state.queues.data[idx]
        queue.items = items
        Vue.set(state.queues.data, idx, queue)
      }
      fetch(`/api/queue/${state.queues.current}/scripts/`).then(res=>{
        if (res.ok){ return res.json() }
      }).then(scripts=>{
        var idx = state.queues.data.findIndex(q=> q.name == state.queues.current )
        if (idx == -1){ return }
        var queue = state.queues.data[idx]
        queue.scripts = scripts
        Vue.set(state.queues.data, idx, queue)
      }).catch(err=>{
        console.log(err)
      })
    }).catch((err)=>{
      console.log(err)
    })
  },
  methods: {
    select(script){
      state.current = JSON.parse(JSON.stringify(initial.current))
      state.current.script = script
    },
  }
}
</script>
<style lang="less" scoped>
@import '../styles/variables.less';
</style>
