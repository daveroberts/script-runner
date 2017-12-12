<template>
  <div>
    <h1><i class="fa fa-list-ol" aria-hidden="true"></i> Queue: {{queue}}</h1>
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
    <div v-if="scripts">
      <h2>Scripts</h2>
      <div style="margin-bottom: 2em;">
        <ul v-if="scripts.length">
          <li v-for="script in scripts">
            <a :href="'/#/scripts/'+script.id" @click="select(script)" class="script_link">{{script.name}}</a>
          </li>
        </ul>
      </div>
    </div>
    <span v-else style="font-style: italic">No scripts set to pick up from this queue</span>
    <div v-if="!items">
      Loading...
    </div>
    <div v-else>
      <table class="table">
        <thead>
          <tr>
            <th>Key</th>
            <th>State</th>
            <th></th>
            <th>Added At</th>
            <td></td>
          </tr>
        </thead>
        <tbody v-if="items.length">
          <tr v-for="item in items">
            <td class="small">
              <a :href="'/api/queue_item/'+item.item_key">
                <pre>{{item.item_key}}</pre>
              </a>
            </td>
            <td class="small">{{item.state}}</td>
            <td class="small">
              <span v-if="item.state=='DONE'">
                <a href="#" @click.prevent="requeue(item)"><i class="fa fa-refresh" aria-hidden="true"></i></a>
              </span>
            </td>
            <td class="small">{{pretty_date(item.created_at)}}</td>
            <td class="small">
              <a href="#" @click.prevent="ask_delete(item)"><i class="fa fa-trash" aria-hidden="true"></i></a>
            </td>
          </tr>
        </tbody>
        <tbody v-else>
          <tr>
            <td colspan="4" style="text-align: center; font-style: italic; padding: 2em;">This queue has no items</td>
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
import Helpers from '../helpers.js'
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
    queue(){ return state.queues.current },
    items(){
      if (state.queues.data == null){ return null }
      var idx = state.queues.data.findIndex(queue => queue.name == state.queues.current)
      if (idx == -1){ return null }
      return state.queues.data[idx].items
    },
    scripts(){
      if (state.queues.data == null){ return null }
      var idx = state.queues.data.findIndex(queue => queue.name == state.queues.current)
      if (idx == -1){ return null }
      return state.queues.data[idx].scripts
    }
  },
  created: function(){
    state.queues.current = this.$route.params.name
    fetch(`/api/queues/${state.queues.current}`).then((res)=>{
      if (res.ok){ return res.json() }
    }).then((items)=>{
      if (state.queues.data == null){ state.queues.data = [] }
      var idx = state.queues.data.findIndex(q=> q.name == state.queues.current )
      if (idx == -1){
        state.queues.data.push({name: state.queues.current, scripts: null, items: items})
      } else {
        var queue = state.queues.data[idx]
        queue.items = items
        Vue.set(state.queues.data, idx, queue)
      }
      fetch(`/api/queue/${state.queues.current}/scripts/`).then(res=>{
        if (res.ok){ return res.json() }
      }).then(scripts=>{
        var idx = state.queues.data.findIndex(q=> q.name == state.queues.current )
        if (idx == -1){ return }
        var queue = state.queues.data[idx]
        queue.scripts = scripts
        Vue.set(state.queues.data, idx, queue)
      }).catch(err=>{
        console.log(err)
      })
    }).catch((err)=>{
      console.log(err)
    })
  },
  mixins: [Helpers],
  methods: {
    select(script){
      state.current = JSON.parse(JSON.stringify(initial.current))
      state.current.script = script
    },
    confirm_delete(){
      var old_state = this.doomed_item.state
      this.doomed_item.state = "DELETING"
      fetch(`/api/queue_item/${this.doomed_item.id}/`, { method: 'DELETE' }).then(res => {
        if (res.ok){
          if (state.queues.data == null){ return null }
          var idx = state.queues.data.findIndex(queue => queue.name == state.queues.current)
          if (idx == -1){ return null }
          var items = state.queues.data[idx].items
          idx = items.indexOf(this.doomed_item)
          if (idx == -1){ return }
          items.splice(idx, 1)
          this.modal.show = false
          this.doomed_item = null
        }
      }).catch(err => {
        console.log(err)
        this.doomed_item.state = old_state
      })
    },
    hide_modal(){ this.modal.show = false },
    ask_delete(item){
      this.doomed_item = item
      this.modal.show = true
    },
    requeue(item){
      var old_state = item.state
      item.state = "REQUEUEING"
      fetch(`/api/queue_item/${item.id}/requeue/`, { method: 'POST' }).then(res => {
        if (res.ok){
          item.state = 'NEW'
        } else {
          item.state = old_state
        }
      }).catch(err => {
        item.state = old_state
        console.log(err)
      })
    },
  }
}
</script>
<style lang="less" scoped>
@import '../styles/variables.less';
</style>
