<template>
  <div>
    <h1>Data Explorer</h1>
    <h2><i class="fa fa-tags" aria-hidden="true"></i> Data Storage</h2>
    <div v-if="!tags">
      Loading...
    </div>
    <table v-else class="collection mini_table">
      <thead>
        <tr>
          <th>Name</th>
          <th>Total</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="tag in tags">
          <td><a :href="'/#/tags/'+tag.name">{{tag.name}}</a></td>
          <td>{{tag.total}}</td>
        </tr>
      </tbody>
    </table>
    <h2><i class="fa fa-list-ol" aria-hidden="true"></i> Queues</h2>
    <div v-if="!queues">
      Loading...
    </div>
    <table v-else class="collection mini_table">
      <thead>
        <tr>
          <th>Name</th>
          <th>Processed</th>
          <th>Waiting</th>
          <th>Error</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="info in queues">
          <td><a :href="'/#/queues/'+info.name">{{info.name}}</a></td>
          <td>{{info.counts.DONE||0}}</td>
          <td>{{info.counts.NEW||0}}</td>
          <td>{{info.counts.ERROR||0}}</td>
        </tr>
      </tbody>
    </table>
    <h2><i class="fa fa-object-group" aria-hidden="true"></i> Sets</h2>
    <div v-if="!sets">
      Loading...
    </div>
    <table v-else class="collection mini_table">
      <thead>
        <tr>
          <th>Name</th>
          <th>Total</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="info in sets">
          <td><a :href="'/#/sets/'+info.name">{{info.name}}</a></td>
          <td>{{info.total||0}}</td>
        </tr>
      </tbody>
    </table>
    <h2><i class="fa fa-key" aria-hidden="true"></i> Dictionaries</h2>
    <div v-if="!dictionaries">
      Loading...
    </div>
    <table v-else class="collection mini_table">
      <thead>
        <tr>
          <th>Name</th>
          <th>Total</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="info in dictionaries">
          <td><a :href="'/#/dictionaries/'+info.name">{{info.name}}</a></td>
          <td>{{info.total||0}}</td>
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
    }).then( sets => {
      if (state.sets.data == null){ state.sets.data = [] }
      Object.keys(sets).forEach( set =>{
        var total = sets[set]
        var idx = state.sets.data.findIndex(s=>s.name==set)
        if (idx == -1){ state.sets.data.push({name: set, total: total, items: null}) }
        else {
          var entry = state.sets.data[idx]
          entry.total = total
          Vue.set(state.sets.data, idx, entry)
        }
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
        var idx = state.dictionaries.data.findIndex(d=>d.name==dictionary.name)
        if (idx == -1){ state.dictionaries.data.push({name: dictionary.name, total: dictionary.total, items: null}) }
        else{
          var entry = state.dictionaries.data[idx]
          entry.total = total
          Vue.set(state.dictionaries.data, idx, entry)
        }
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
      Object.keys(queues).forEach( queue =>{
        var info = queues[queue]
        var idx = state.queues.data.findIndex(q=>q.name==queue)
        if (idx == -1){ state.queues.data.push({name: queue, counts: info, scripts: null, items: null}) }
        else {
          var entry = state.queues.data[idx]
          entry.counts = info
          Vue.set(state.queues.data, idx, entry)
        }
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
