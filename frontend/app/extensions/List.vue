<template>
  <div>
    <h1>Code Extensions</h1>
    <div v-if="!extensions">
      Loading...
    </div>
    <div v-else>
      <div style="margin-left: 2em;" v-for="(class_info, klass) in extensions">
        <h2>
          <a href="#" class="extension_link" @click.prevent="toggle_ext(klass)"><i :class="['fa', class_info.icon]" style="display: inline-block; width: 1.5em;" aria-hidden="true"></i>{{klass}}</a>
        </h2>
        <div v-if="show_methods(klass)">
          <div v-if="show_methods(klass)" style="margin-left: 2em;">
            <methods :class_info="class_info"></methods>
          </div>
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
      state.extensions.list = extensions
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
