<template>
  <div>
    <h1><i class="fa fa-list-ol" aria-hidden="true"></i> Queue: {{queue}} <a href="#" @click.prevent="refresh()"><i class="fa fa-refresh" aria-hidden="true"></i></a></h1>
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
    <div v-if="script">
      Processed by <a :href="'/#/scripts/'+script.id" @click="select(script)" class="script_link">{{script.name}}</a>
    </div>
    <span v-else style="font-style: italic">No script set to process data from this queue</span>
    <div v-if="!items">
      Loading...
    </div>
    <div v-else>
      <table class="table">
        <thead>
          <tr>
            <th>Item</th>
            <th>State</th>
            <th></th>
            <th>Added At</th>
            <td></td>
          </tr>
        </thead>
        <tbody v-if="items.length">
          <tr v-for="item in items">
            <td class="small">
              <pre class="json" v-html="syntax_highlight(item.summary)"></pre>
            </td>
            <td class="small">{{item.state}}</td>
            <td class="small">
              <span v-if="item.state=='DONE' || item.state=='ERROR'">
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
const loadQueueItems = () => {
  return new Promise((resolve, reject) => {
    fetch(`/api/queues/${state.queues.current}`, {
         credentials: 'include'
    }).then( res => {
      if (res.ok){ return res.json() }
    }).then( items => {
      if (state.queues.data == null){ state.queues.data = [] }
      var idx = state.queues.data.findIndex(q => q.name == state.queues.current )
      if (idx == -1){
        state.queues.data.push({name: state.queues.current, counts: null, script: null, items: items})
      } else {
        var queue = state.queues.data[idx]
        queue.items = items
        Vue.set(state.queues.data, idx, queue)
      }
      resolve()
    }).catch( err => {
      console.log(err)
      reject()
    })
  })
}
export default {
  data: function(){
    return {
      state: state,
      modal: {
        show: false,
        title: "Delete Item",
        text: "Are you sure you want to delete this item?"
      },
      doomed_item: null,
      refresh_timer: null
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
    script(){
      if (state.queues.data == null){ return null }
      var idx = state.queues.data.findIndex(queue => queue.name == state.queues.current)
      if (idx == -1){ return null }
      return state.queues.data[idx].script
    }
  },
  created: function(){
    state.queues.current = this.$route.params.name
    loadQueueItems().then( () => {
      fetch(`/api/queue/${state.queues.current}/script/`, {
        credentials: 'include'
      }).then( res => {
        if (res.ok){ return res.json() }
      }).then( script => {
        var idx = state.queues.data.findIndex(q=> q.name == state.queues.current )
        if (idx == -1){ return }
        var queue = state.queues.data[idx]
        queue.script = script
        Vue.set(state.queues.data, idx, queue)
      }).catch(err=>{
        console.log(err)
      })
    })
    this.refresh_timer = setInterval(loadQueueItems, 5000)
  },
  beforeDestroy: function(){
    if (this.refresh_timer){ clearInterval(this.refresh_timer) }
  },
  mixins: [Helpers],
  methods: {
    refresh(){
      loadQueueItems().then(() => { senate.flash("Refreshed") })
    },
    select(script){
      state.current = JSON.parse(JSON.stringify(initial.current))
      state.current.script = script
    },
    confirm_delete(){
      var old_state = this.doomed_item.state
      this.doomed_item.state = "DELETING"
      fetch(`/api/queue_item/${this.doomed_item.id}/`, {
        method: 'DELETE',
        credentials: 'include'
      }).then(res => {
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
      fetch(`/api/queue_item/${item.id}/requeue/`, {
        method: 'POST',
        credentials: 'include'
      }).then(res => {
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
