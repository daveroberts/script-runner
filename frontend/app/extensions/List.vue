<template>
  <div>
    <h1>Extension Methods</h1>
    <div v-if="!extensions">
      Loading...
    </div>
    <div v-else>
      <div v-for="ext in extensions">
        <h2><a href="#" class="extension_link" @click.prevent="toggle_ext(ext.name)"><i :class="['fa', ext.icon]" style="display: inline-block; width: 1.5em;" aria-hidden="true"></i> {{ext.name}}</a></h2>
        <div v-if="show_methods(ext.name)">
          <methods :methods="ext.methods"></methods>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import state from '../state/state.js'
import * as senate from '../state'
import initial from '../state/initial.js'
import Methods from './Methods.vue'
export default {
  data: function(){
    return {
      state: state,
      toggles: []
    }
  },
  computed: {
    extensions(){ return state.extensions.list },
  },
  components: { Methods },
  created: function(){
    fetch(`/api/extensions`, {
      credentials: 'include'
    }).then((res)=>{
      if (res.ok){ return res.json() }
    }).then(extensions=>{
      if (!state.extensions.list){ state.extensions.list = [] }
      extensions.forEach(ext => {
        var idx = state.extensions.list.findIndex(e=>e.name==ext.name)
        if (idx == -1){ state.extensions.list.push(ext) }
      })
    }).catch((err)=>{
      console.log(err)
    })
  },
  methods: {
    toggle_ext(name){
      var idx = this.toggles.indexOf(name)
      if (idx == -1){
        this.toggles.push(name)
      } else {
        this.toggles.splice(idx, 1)
      }
    },
    show_methods(name){
      var idx = this.toggles.indexOf(name)
      return idx != -1
    }
  }
}
</script>
<style lang="less" scoped>
@import '../styles/variables.less';
.extension_link{ text-decoration: none; color: @font-color; font-size: @font-size-x-large; }
</style>
