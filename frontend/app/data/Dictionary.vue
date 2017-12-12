<template>
  <div>
    <h1><i class="fa fa-key" aria-hidden="true"></i> {{dictionary}}</h1>
    <div v-if="!items">
      Loading...
    </div>
    <div v-else>
      <input type="text" class="form_input" style="width: 15em !important;" v-model="search" />
      <i class="fa fa-search large base" style="position: relative; left: -1.7em;" aria-hidden="true"></i>
      <table class="table">
        <thead>
          <tr>
            <th>Key</th>
            <th>Value</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(value,key) in filtered_items">
            <td class="small" style="width: 30em;">{{key}}</td>
            <td><pre class="small json" v-html="syntax_highlight(value)"></pre></td>
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
import Helpers from '../helpers.js'
export default {
  mixins: [Helpers],
  data: function(){
    return {
      state: state,
      search: ""
    }
  },
  computed: {
    dictionary(){ return state.dictionaries.current },
    filtered_items(){
      if (state.dictionaries.data == null){ return null }
      var idx = state.dictionaries.data.findIndex(dict => dict.name == state.dictionaries.current)
      if (idx == -1){ return null }
      var items = state.dictionaries.data[idx].items
      var matching_items = {}
      var re = new RegExp(`.*${this.search}.*`, 'im')
      for(const key in items){
        var value = items[key]
        var str_value = value
        if (typeof(value) == "object"){ str_value = JSON.stringify(value) }
        if (str_value.match(re)){ matching_items[key] = value }
      }
      return matching_items
    },
    items(){
      if (state.dictionaries.data == null){ return null }
      var idx = state.dictionaries.data.findIndex(dict => dict.name == state.dictionaries.current)
      if (idx == -1){ return null }
      return state.dictionaries.data[idx].items
    }
  },
  created: function(){
    state.dictionaries.current = this.$route.params.name
    fetch(`/api/dictionaries/${this.$route.params.name}`).then((res)=>{
      if (res.ok){ return res.json() }
    }).then((items)=>{
      if (state.dictionaries.data == null){
        state.dictionaries.data = []
      }
      var idx = state.dictionaries.data.findIndex(d=> d.name == state.dictionaries.current )
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
