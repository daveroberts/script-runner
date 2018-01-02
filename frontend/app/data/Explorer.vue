<template>
  <div>
    <h1>Data Explorer</h1>
    <h2><i class="fa fa-tags" aria-hidden="true"></i> Data Storage</h2>
    <div v-if="!tags">
      Loading...
    </div>
    <table v-else class="collection mini_table">
      <tbody>
        <tr v-for="tag in tags">
          <td>{{tag.total}}</td>
          <td><a :href="'/tags/'+tag.name">{{tag.name}}</a></td>
        </tr>
      </tbody>
    </table>
    <h2><i class="fa fa-list-ol" aria-hidden="true"></i> Queues</h2>
    <div v-if="!queues">
      Loading...
    </div>
    <div v-else v-for="data in queues" class="collection">
      <a :href="'/#/queues/'+data.name" class="collection_item">{{data.name}}</a>
    </div>
    <h2><i class="fa fa-object-group" aria-hidden="true"></i> Sets</h2>
    <div v-if="!sets">
      Loading...
    </div>
    <div v-else v-for="data in sets" class="collection">
      <a :href="'/#/sets/'+data.name" class="collection_item">{{data.name}}</a>
    </div>
    <h2><i class="fa fa-key" aria-hidden="true"></i> Dictionaries</h2>
    <div v-if="!dictionaries">
      Loading...
    </div>
    <div v-else v-for="data in dictionaries" class="collection">
      <a :href="'/#/dictionaries/'+data.name" class="collection_item">{{data.name}}</a>
    </div>
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
    tags(){ return state.tags.data },
    sets(){ return state.sets.data },
    dictionaries(){ return state.dictionaries.data },
    queues(){ return state.queues.data },
  },
  created: function(){
    fetch(`/api/tags`, {
         credentials: 'include'
    }).then((res)=>{
      if (res.ok){ return res.json() }
    }).then((tags)=>{
      if (state.tags.data == null){ state.tags.data = [] }
      tags.forEach(tag =>{
        var idx = state.tags.data.findIndex(t=>t.name==tag.name)
        if (idx == -1){ state.tags.data.push({name: tag.name, total: tag.total, items: null}) }
        else {
          var entry = state.tags.data[idx]
          entry.total = tag.total
          Vue.set(state.tags.data, idx, entry)
        }
      })
    }).catch((err)=>{
      console.log(err)
    })
    fetch(`/api/sets`, {
         credentials: 'include'
    }).then((res)=>{
      if (res.ok){ return res.json() }
    }).then((sets)=>{
      if (state.sets.data == null){ state.sets.data = [] }
      sets.forEach(set =>{
        var idx = state.sets.data.findIndex(s=>s.name==set)
        if (idx == -1){ state.sets.data.push({name: set, items: null}) }
      })
    }).catch((err)=>{
      console.log(err)
    })
    fetch(`/api/dictionaries`, {
         credentials: 'include'
    }).then((res)=>{
      if (res.ok){ return res.json() }
    }).then((dictionaries)=>{
      if (state.dictionaries.data == null){ state.dictionaries.data = [] }
      dictionaries.forEach(dictionary =>{
        var idx = state.dictionaries.data.findIndex(d=>d.name==dictionary)
        if (idx == -1){ state.dictionaries.data.push({name: dictionary, items: null}) }
      })
    }).catch((err)=>{
      console.log(err)
    })
    fetch(`/api/queues`, {
         credentials: 'include'
    }).then((res)=>{
      if (res.ok){ return res.json() }
    }).then((queues)=>{
      if (state.queues.data == null){ state.queues.data = [] }
      queues.forEach(queue =>{
        var idx = state.queues.data.findIndex(q=>q.name==queue)
        if (idx == -1){ state.queues.data.push({name: queue, scripts: null, items: null}) }
      })
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
.collection{ margin-left: 1.5em; }
</style>
