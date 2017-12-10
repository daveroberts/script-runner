<template>
  <div>
    <h1>{{set}}</h1>
    <div v-if="!items">
      Loading...
    </div>
    <div v-else>
      <table class="table">
        <thead>
          <tr>
            <th>Item</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="item in items">
            <td><pre style="font-size: 10pt;">{{item}}</pre></td>
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
    set(){ return state.sets.current },
    items(){
      if (state.sets.data == null){ return null }
      var idx = state.sets.data.findIndex(set => set.name == state.sets.current)
      if (idx == -1){ return null }
      return state.sets.data[idx].items
    }
  },
  created: function(){
    state.sets.current = this.$route.params.name
    fetch(`/api/sets/${this.$route.params.name}`).then((res)=>{
      if (res.ok){ return res.json() }
    }).then((items)=>{
      if (state.sets.data == null){ state.sets.data = [] }
      var idx = state.sets.data.findIndex(set=> set.name == state.sets.current )
      if (idx == -1){
        state.sets.data.push({name: state.sets.current, items: items})
      } else {
        var set = state.sets.data[idx]
        set.items = items
        Vue.set(state.sets.data, idx, set)
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
