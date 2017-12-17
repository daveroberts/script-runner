<template>
  <div>
    <h1><i class="fa fa-tag" aria-hidden="true"></i> Data tagged with `{{tag}}`</h1>
    <div v-bind:class="['modal', modal.show ? 'modal_show' : '']">
      <div class="modal_inner">
        <div class="modal_titlebar">
          {{ modal.title }}
        </div>
        <div class="modal_content">
          <p class="modal_text">{{ modal.text }}</p>
          <div>
            <button v-on:click.prevent="confirm_delete()" class="btn btn-danger"><i class="fa fa-trash" aria-hidden="true"></i> Delete Data Item</button>
            <button v-on:click.prevent="hide_modal()" class="btn"><i class="fa fa-ban" aria-hidden="true"></i> Don't do anything</button>
          </div>
        </div>
      </div>
    </div>
    <div v-if="!items">
      Loading...
    </div>
    <div v-else>
      <table class="table">
        <thead>
          <tr>
            <th>Item Key</th>
            <th>Image Preview</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="item in items">
            <td>
              <a :href="'/api/data_item/'+item.key">
                <pre class="small">{{item.key}}</pre>
              </a>
            </td>
            <td>
              <a :href="'/api/data_item/'+item.key">
                <span v-if="is_image_mime_type(item.preview_mime_type)">
                  <img class="image_preview" :src="'/api/data_item_preview/'+item.key" alt="Preview Image" />
                </span>
              </a>
            </td>
            <td><a href="#" @click.prevent="ask_delete(item)"><i class="fa fa-trash" aria-hidden="true"></i></a></td>
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
      modal: {
        show: false,
        title: "Delete Item",
        text: "Are you sure you want to delete this item?"
      },
      doomed_item: null
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
    fetch(`/api/tags/${state.tags.current}/`, {
         credentials: 'include'
    }).then((res)=>{
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
    is_image_mime_type(mime_type){
      if (!mime_type){ return false }
      return mime_type.match(/^image\/.*/)
    },
    confirm_delete(){
      fetch(`/api/data_item/${this.doomed_item.key}/`, {
        method: 'DELETE',
        credentials: 'include'
      }).then(res => {
        if (res.ok){
          if (state.tags.data == null){ return }
          var idx = state.tags.data.findIndex(tag => tag.name == state.tags.current)
          if (idx == -1){ return }
          var items = state.tags.data[idx].items
          idx = items.indexOf(this.doomed_item)
          if (idx == -1){ return }
          items.splice(idx, 1)
          this.modal.show = false
          this.doomed_item = null
        }
      }).catch(err => {
        console.log(err)
      })
    },
    hide_modal(){ this.modal.show = false },
    ask_delete(item){
      this.doomed_item = item
      this.modal.show = true
    }
  }
}
</script>
<style lang="less" scoped>
@import '../styles/variables.less';
.image_preview{ border: 1px solid #777; }
</style>
