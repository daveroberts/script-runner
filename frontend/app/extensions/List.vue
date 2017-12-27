<template>
  <div>
    <h1>Code Extensions</h1>
    <div v-if="!extensions">
      Loading...
    </div>
    <div v-else>
      <div v-for="(classes, module) in extensions">
        <h2>
          <a href="#" class="extension_link" @click.prevent="toggle_ext(module)">{{module}}</a>
        </h2>
        <div v-if="show_methods(module)">
          <div v-for="(class_info, klass) in classes">
            <a href="#" @click.prevent="toggle_ext(module+'::'+klass)"><h3><i :class="['fa', class_info.icon]" style="display: inline-block; width: 1.5em;" aria-hidden="true"></i>{{module}}::{{klass}}</h3></a>
            <div v-if="show_methods(module+'::'+klass)">
              <methods :prefix="klass" :methods="class_info.class_methods"></methods>
              <div>Instance Methods</div>
              <methods :methods="class_info.instance_methods"></methods>
            </div>
          </div>
        </div>
      </div>
      <!--div v-for="ext in extensions">
        <h2><a href="#" class="extension_link" @click.prevent="toggle_ext(ext.name)"><i :class="['fa', ext.icon]" style="display: inline-block; width: 1.5em;" aria-hidden="true"></i> {{ext.name}}</a></h2>
        <div v-if="show_methods(ext.name)">
          <methods :methods="ext.methods"></methods>
        </div>
      </div-->
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
