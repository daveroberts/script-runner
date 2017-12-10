<template>
  <div>
    <h1>{{tag}}</h1>
    <div v-if="!items">
      Loading...
    </div>
    <div v-else>
      <table class="table">
        <thead>
          <tr>
            <th>Item Key</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="item in items">
            <td>
              <a :href="'/api/data_item/'+item.key">
                <pre>{{item.key}}</pre>
              </a>
            </td>
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
    tag(){ return state.tags.current },
    items(){
      if (state.tags.data == null){ return null }
      var idx = state.tags.data.findIndex(tag => tag.name == state.tags.current)
      if (idx == -1){ return null }
      return state.tags.data[idx].items
    }
  },
  created: function(){
    state.tags.current = this.$route.params.name
    fetch(`/api/tags/${state.tags.current}/`).then((res)=>{
      if (res.ok){ return res.json() }
    }).then((items)=>{
      if (state.tags.data == null){ state.tags.data = [] }
      var idx = state.tags.data.findIndex(t=> t.name == state.tags.current )
      if (idx == -1){
        state.tags.data.push({name: state.tags.current, items: items})
      } else {
        var tag = state.tags.data[idx]
        tag.items = items
        Vue.set(state.tags.data, idx, tag)
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
