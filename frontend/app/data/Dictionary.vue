<template>
  <div>
    <h1>{{dictionary}}</h1>
    <table class="table">
      <thead>
        <tr>
          <th>Key</th>
          <th>Value</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(value,key) in items">
          <td>{{key}}</td>
          <td><pre>{{value}}</pre></td>
        </tr>
      </tbody>
    </table>
  </div>
</template>
<script>
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
    dictionary(){ return state.dictionaries.current },
    items(){
      var idx = state.dictionaries.data.findIndex(dict => dict.name == state.dictionaries.current)
      if (idx == -1){ return [] }
      return state.dictionaries.data[idx].items
    }
  },
  created: function(){
    state.dictionaries.current = this.$route.params.name
    fetch(`/api/dictionaries/${this.$route.params.name}`).then((res)=>{
      if (res.ok){ return res.json() }
    }).then((items)=>{
      var idx = state.dictionaries.data.findIndex((d)=>{ d.name == state.dictionaries.current})
      if (idx == -1){
        state.dictionaries.data.push({name: state.dictionaries.current, items: items})
      } else {
        var dict = state.dictionaries.data[idx]
        dict.items = items
        Vue.set(state.dictionaries.data, idx, dict)
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
