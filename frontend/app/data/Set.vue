<template>
  <div>
    <h1><i class="fa fa-object-group" aria-hidden="true"></i> {{set}}</h1>
    <div v-bind:class="['modal', modal.show ? 'modal_show' : '']">
      <div class="modal_inner">
        <div class="modal_titlebar">
          {{ modal.title }}
        </div>
        <div class="modal_content">
          <p class="modal_text">{{ modal.text }}</p>
          <div>
            <button v-on:click.prevent="confirm_delete()" class="btn btn-danger"><i class="fa fa-trash" aria-hidden="true"></i> Delete Item</button>
            <button v-on:click.prevent="hide_modal()" class="btn"><i class="fa fa-ban" aria-hidden="true"></i> Don't do anything</button>
          </div>
        </div>
      </div>
    </div>
    <div v-if="!items">
      Loading...
    </div>
    <div v-else>
      <input type="text" class="form_input" style="width: 15em !important;" v-model="search" />
      <i class="fa fa-search large base" style="position: relative; left: -1.7em;" aria-hidden="true"></i>
      <table class="table">
        <thead>
          <tr>
            <th>Item</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="item in filtered_items">
            <td>
              <pre style="font-size: 10pt;">{{item.value}}</pre>
            </td>
            <td>
              <a href="#" @click.prevent="ask_delete(item)"><i class="fa fa-trash" aria-hidden="true"></i></a>
            </td>
          </tr>
        </tbody>
      </table>
      <h2>
        <a href="#" style="text-decoration: none;" @click.prevent="show_add_new = !show_add_new">
          <span style="display: inline-block; width: 0.5em;" v-if="show_add_new"><i class="fa fa-caret-down" aria-hidden="true"></i></span>
          <span style="display: inline-block; width: 0.5em;" v-else><i class="fa fa-caret-right" aria-hidden="true"></i></span>
          <span>Add Item to Set</span>
        </a>
      </h2>
      <form v-if="show_add_new" @submit.prevent="add_item()">
        <table>
          <tbody>
            <tr class="form_row">
              <th class="form_label">Value</th>
              <td>
                <input type="text" v-model="new_item" />
              </td>
            </tr>
            <tr class="form_row">
              <th></th>
              <td>
                <button type="submit" class="btn btn-main" @click.prevent="add_item()"> <i class="fa fa-floppy-o" aria-hidden="true"></i> Add Item to Set</button>
              </td>
            </tr>
          </tbody>
        </table>
      </form>
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
      search: "",
      show_add_new: false,
      new_item: "",
      modal: {
        show: false,
        title: "Delete Item",
        text: "Are you sure you want to delete this item?"
      },
      doomed_item: null
    }
  },
  computed: {
    set(){ return state.sets.current },
    filtered_items(){
      if (state.sets.data == null){ return null }
      var idx = state.sets.data.findIndex(set => set.name == state.sets.current)
      if (idx == -1){ return null }
      var items = state.sets.data[idx].items
      var matching_items = []
      var re = new RegExp(`.*${this.search}.*`, 'im')
      for(var i=0; i<items.length; i++){
        var str_value = items[i].value
        if (typeof(items[i].value) == "object"){ str_value = JSON.stringify(items[i].value) }
        if (str_value.match(re)){ matching_items.push(items[i]) }
      }
      return matching_items
    },
    items(){
      if (state.sets.data == null){ return null }
      var idx = state.sets.data.findIndex(set => set.name == state.sets.current)
      if (idx == -1){ return null }
      return state.sets.data[idx].items
    }
  },
  created: function(){
    state.sets.current = this.$route.params.name
    fetch(`/api/sets/${this.$route.params.name}`, {
         credentials: 'include'
    }).then((res)=>{
      if (res.ok){ return res.json() }
    }).then((items)=>{
      if (state.sets.data == null){ state.sets.data = [] }
      var idx = state.sets.data.findIndex(set=> set.name == state.sets.current )
      if (idx == -1){
        state.sets.data.push({name: state.sets.current, items: items})
      } else {
        var set = state.sets.data[idx]
        set.items = items
        Vue.set(state.sets.data, idx, set)
      }
    }).catch((err)=>{
      console.log(err)
    })
  },
  methods: {
    add_item(){
      fetch(`/api/set_item/${state.sets.current}/`, {
        method: 'POST',
        credentials: 'include',
        body: this.new_item
      }).then(res => {
        console.log(res)
        if (res.ok){ return res.json() }
        throw new Error("Duplicate?")
      }).then( item => {
        console.log("Then invoked")
        console.log(item)
        if (state.sets.data == null){ return null }
        var idx = state.sets.data.findIndex(set => set.name == state.sets.current)
        if (idx == -1){ return null }
        var items = state.sets.data[idx].items
        items.push(item)
        this.new_item = ""
        this.show_add_new = false
        senate.flash("Item added")
      }).catch(err => {
        console.log(err)
        senate.flash("Could not add item to set", "danger")
      })
    },
    confirm_delete(){
      fetch(`/api/set_item/${this.doomed_item.id}/`, {
        method: 'DELETE',
        credentials: 'include'
      }).then(res => {
        if (res.ok){
          if (state.sets.data == null){ return null }
          var idx = state.sets.data.findIndex(set => set.name == state.sets.current)
          if (idx == -1){ return null }
          var items = state.sets.data[idx].items
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
</style>
