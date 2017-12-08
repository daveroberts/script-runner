<template>
  <div>
    <h1>Data Explorer</h1>
    <h2>Tags</h2>
    <div v-for="(tag,name) in tags">
      <a :href="'/#/tags/'+name">{{name}}</a>
    </div>
    <h2>Sets</h2>
    <div v-for="(set,name) in sets">
      <a :href="'/#/sets/'+name">{{name}}</a>
    </div>
    <h2>Dictionaries</h2>
    <div v-if="!dictionaries">
      Loading...
    </div>
    <div v-else v-for="data in dictionaries">
      <a :href="'/#/dictionaries/'+data.name">{{data.name}}</a>
    </div>
    <h2>Queues</h2>
    <div v-for="(q,name) in queues">
      <a :href="'/#/queues/'+name">{{name}}</a>
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
    fetch(`/api/tags`).then((res)=>{
      if (res.ok){ return res.json() }
    }).then((tags)=>{
      tags.forEach(tag =>{
        if (!(tag in state.tags.data)){
          state.tags.data[tag] = {
            items: []
          }
        }
      })
    }).catch((err)=>{
      console.log(err)
    })
    fetch(`/api/sets`).then((res)=>{
      if (res.ok){ return res.json() }
    }).then((sets)=>{
      sets.forEach(set =>{
        if (!(set in state.sets.data)){
          state.sets.data[set] = {
            items: []
          }
        }
      })
    }).catch((err)=>{
      console.log(err)
    })
    fetch(`/api/dictionaries`).then((res)=>{
      if (res.ok){ return res.json() }
    }).then((dictionaries)=>{
      if (state.dictionaries.data == null){
        state.dictionaries.data = []
      }
      dictionaries.forEach(dictionary =>{
        var idx = state.dictionaries.data.findIndex(d=>d.name==dictionary)
        if (idx == -1){
          state.dictionaries.data.push({name: dictionary, items: null})
        }
      })
    }).catch((err)=>{
      console.log(err)
    })
    fetch(`/api/queues`).then((res)=>{
      if (res.ok){ return res.json() }
    }).then((queues)=>{
      queues.forEach(queue =>{
        if (!(queue in state.queues.data)){
          state.queues.data[queue] = {
            items: []
          }
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
</style>
