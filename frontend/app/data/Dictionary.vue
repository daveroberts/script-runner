<template>
  <div>
    <h1>Anything?</h1>
    <h1>{{dictionary}}</h1>
    <div v-for="(key, value) in values">
      Key: {{key}} Value: {{value}}
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
    dictionary(){ return state.dictionaries.current },
    values(){
      var idx = state.dictionaries.data.findIndex((d)=>{ d.name == state.dictionaries.current})
      if (idx != -1){ return state.dictionaries.data[idx].items }
      return []
    },
  },
  created: function(){
    fetch(`/api/dictionaries/${this.$route.params.name}`).then((res)=>{
      if (res.ok){ return res.json() }
    }).then((items)=>{
      console.log(items)
      console.log(state.dictionaries.data)
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
