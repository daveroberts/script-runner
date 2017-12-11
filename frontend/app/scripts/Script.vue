<template>
  <div>
    <div v-if="script">
      <div class="outer">
        <div class="left_panel">
          <h1 v-if="script.name">{{script.name}}</h1>
          <h1 v-else>Code</h1>
          <div class="code_editor">
            <codemirror v-model="script.code" :options="editorOptions"></codemirror>
          </div>
          <div v-if="script.id && script.code != orig_code">
            <button type="button" class="btn btn-small" @click.prevent="save()"> <i class="fa fa-floppy-o" aria-hidden="true"></i> Save Changes</button>
            <button type="button" class="btn btn-danger btn-small" @click.prevent="undo()"> <i class="fa fa-undo" aria-hidden="true"></i> Undo Changes</button>
          </div>
          <div style="margin-top: 1em;" class="fancy_checkbox">
            <input id="input_send" type="checkbox" v-model="state.current.input.send" />
            <label for="input_send"></label>
          </div>
          <label for="input_send">Send Input</label>
          <div v-if="state.current.input.send">
            <div class="code_editor">
              <codemirror v-model="state.current.input.payload" :options="editorOptions"></codemirror>
            </div>
            <div v-if="script.id && state.current.input.payload && state.current.input.payload != script.default_input"><button type="button" class="btn btn-small" @click="save_as_default_input(script.id, state.current.input.payload)"><i class="fa fa-save" aria-hidden="true"></i> Save as default test input</button></div>
          </div>
          <div style="margin: 1em 0;">
            <a class="extensions_toggle base" href="#" @click.prevent="toggle_extensions_pane()">
              <span v-if="!show_extensions"><i class="fa fa-caret-right" aria-hidden="true"></i> Code Extensions</span>
              <span v-else><i class="fa fa-caret-down" aria-hidden="true"></i> Hide Extensions</span>
            </a>
          </div>
          <div v-if="show_extensions">
            <div v-if="!extensions">
              Loading...
            </div>
            <div v-else>
              <div style="margin: 0.5em;" v-for="ext in extensions">
                <div class="fancy_checkbox">
                  <input :id="'check_ext_'+ext.name" type="checkbox" :value="ext.name" v-model="script.extensions" />
                  <label :for="'check_ext_'+ext.name"></label>
                </div>
                <label :for="'check_ext_'+ext.name"><i :class="['fa', ext.icon]" aria-hidden="true"></i> {{ext.name}}</label>
                <div v-if="script.extensions.indexOf(ext.name) > -1">
                  <methods :methods="ext.methods"></methods>
                </div>
              </div>
            </div>
          </div>
          <div style="margin: 1em 0;">
            <button :class="['btn', running?'btn-disabled':'']" :disabled="running" @click="run()">
              <span v-if="!running"><i class="fa fa-circle-o-notch" aria-hidden="true"></i> Run</span>
              <span v-else><i class="fa fa-circle-o-notch fa-spin"></i></i> Running Code</span>
            </button>
          </div>
        </div>
        <div class="right_panel">
          <div v-if="last_run">
            <h1>Output</h1>
            <pre class="json" v-if="last_run.output != null" v-html="syntax_highlight(last_run.output)"></pre>
            <pre class="monospace error" v-if="last_run.error">{{last_run.error}}</pre>
          </div>
        </div>
        <div style="clear: both;"></div>
      </div>
      <div v-if="script.id || save_for_later">
        <h2>
          <a href="#" style="text-decoration: none;" @click.prevent="show_script_details = !show_script_details">
            <span style="display: inline-block; width: 0.5em;" v-if="show_script_details"><i class="fa fa-caret-down" aria-hidden="true"></i></span>
            <span style="display: inline-block; width: 0.5em;" v-else><i class="fa fa-caret-right" aria-hidden="true"></i></span>
            <span><i class="fa fa-info-circle" aria-hidden="true"></i> Script Details</span>
          </a>
        </h2>
        <form v-if="show_script_details" @submit.prevent="save()">
          <table>
            <tbody>
              <tr class="form_row">
                <th :class="['form_label', errors.name?'error-form-label':'']">Name</th>
                <td>
                  <input type="text" v-model="script.name" :class="errors.name?'error-input':''" />
                  <div v-if="errors.name" class="error">{{errors.name}}</div>
                </td>
              </tr>
              <tr class="form_row">
                <th class="form_label">Category</th>
                <td>
                  <input type="text" v-model="script.category" />
                </td>
              </tr>
              <tr class="form_row">
                <th class="form_label">Description</th>
                <td>
                  <input type="text" v-model="script.description" />
                </td>
              </tr>
            </tbody>
            <tbody class="form_section" v-for="(trigger, index) in script.triggers">
              <tr class="form_row" v-if="script.triggers.length > 1">
                <th colspan="2" style="text-align: left;">Trigger #{{index+1}}</th>
              </tr>
              <tr class="form_row">
                <th class="form_label">Type</th>
                <td>
                  <span>
                    <select v-model="trigger.type">
                      <option v-for="type in trigger_types" v-bind:value="type">{{type}}</option>
                    </select>
                    <button type="button" class="btn btn-small btn-danger" @click="remove_trigger(trigger)"><i class="fa fa-minus-circle" aria-hidden="true"></i> remove</button>
                  </span>
                </td>
              </tr>
              <tr class="form_row" v-if="trigger.type == 'CRON'">
                <th class="form_label">Every</th>
                <td>
                  <span><input type="number" style="width: 4em;" v-model="trigger.every" /> minutes</span>
                </td>
              </tr>
              <tr class="form_row" v-if="trigger.type == 'QUEUE'">
                <th class="form_label">Queue Name</th>
                <td>
                  <input type="text" v-model="trigger.queue_name" />
                </td>
              </tr>
              <tr class="form_row" v-if="trigger.type == 'QUEUE' && trigger.queue_name">
                <th class="form_label"></th>
                <td>Inspect <a target="_blank" :href="'/#/queues/'+trigger.queue_name">`{{trigger.queue_name}}` queue</a></td>
              </tr>
            </tbody>
            <tbody>
              <tr class="form_row">
                <th></th>
                <td><button type="button" class="btn btn-small" @click="add_trigger()"><i class="fa fa-plus" aria-hidden="true"></i> Add trigger</button></td>
              </tr>
              <tr class="form_row" v-if="script.triggers && script.triggers.length">
                <th class="form_label"><label for="active">Active?</label></th>
                <td>
                  <div class="fancy_checkbox">
                    <input id="active" type="checkbox" v-model="script.active" />
                    <label for="active"></label>
                  </div>
                </td>
              </tr>
            </tbody>
            <tbody>
              <tr class="form_row">
                <th></th>
                <td>
                  <button type="submit" class="btn btn-main" @click.prevent="save()"> <i class="fa fa-floppy-o" aria-hidden="true"></i> Save</button>
                </td>
              </tr>
            </tbody>
          </table>
        </form>
      </div>
      <div v-if="script.code && runs && runs.length">
        <div v-if="!script.id && !save_for_later" style="margin-top: 3em;">
          <button class="btn" @click="set_save_for_later()"><i class="fa fa-save" aria-hidden="true"></i> Save Script</button>
        </div>
        <div v-if="!script.id" style="margin: 2em 0;" class="warning">This script has not yet been saved.</div>
      </div>
      <div v-if="script.id || (runs && runs.length)">
        <h2><i class="fa fa-bar-chart" aria-hidden="true"></i> Last 10 Runs</h2>
        <div v-if="!runs">
          Loading...
        </div>
        <div v-else>
          <table class="table">
            <thead>
              <tr>
                <th>Output</th>
                <th style="text-align: right;">Run</th>
              </tr>
            </thead>
            <tbody v-if="runs.length == 0">
              <tr>
                <td colspan="2" style="text-align: center; font-style: italic; padding: 1em;">Script has not yet been run</td>
              </tr>
            </tbody>
            <tbody v-else>
              <tr v-for="run in runs">
                <td style="font-size: 10pt;">
                  <pre class="json" v-if="run.output != null" v-html="syntax_highlight(run.output)"></pre>
                  <pre class="monospace error" v-if="run.error">{{run.error}}</pre>
                </td>
                <td style="text-align: right;" class="small">{{pretty_date(run.run_at)}}</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import Vue from 'vue'
import state from '../state/state.js'
import * as senate from '../state'
import initial from '../state/initial.js'
import Methods from '../extensions/Methods.vue'
import Helpers from '../helpers.js'
const loadExtensions = (time = new Date()) => {
  fetch(`/api/extensions/`, {
    credentials: 'include'
  }).then(res => {
    if (res.ok){ return res.json() }
  }).then(extensions => {
    if (!state.extensions.list){ state.extensions.list = [] }
    extensions.forEach(ext => {
      var idx = state.extensions.list.findIndex(e=>e.name==ext.name)
      if (idx == -1){ state.extensions.list.push(ext) }
    })
  }).catch(err => {
    console.log(err)
  })
}
export default {
  data: function(){
    return {
      state: state,
      save_for_later: false,
      orig_code: '',
      trigger_types: ['CRON', 'QUEUE'],
      show_extensions: false,
      show_script_details: true,
      running: false,
      editorOptions: {
        tabSize: 2,
        mode: {
          name: 'clojure',
          json: true
        },
        theme: 'mdn-like',
        lineNumbers: true,
        line: true,
        smartIndent: false
      }
    }
  },
  components: { Methods },
  computed: {
    script(){ return state.current.script },
    runs(){ return state.current.runs },
    last_run(){ if (state.current.runs){ return state.current.runs[0] } else { return null } },
    errors(){ return state.current.field_errors },
    extensions(){ return state.extensions.list }
  },
  created: function(){
    loadExtensions()
    if (this.$route.params.id == 'new'){
      state.current = JSON.parse(JSON.stringify(initial.current))
    }
    if (state.current.script.default_input){
      state.current.input.send = true
      state.current.input.payload = state.current.script.default_input
    }
    if (state.current.script.code){ this.orig_code = state.current.script.code }
    if (!state.current.script || (state.current.script.id != this.$route.params.id) && this.$route.params.id != 'new') {
      state.current = JSON.parse(JSON.stringify(initial.current))
      fetch(`/api/scripts/${this.$route.params.id}`).then((res)=>{
        if (res.ok){ return res.json() }
      }).then((script)=>{
        state.current.script = script
        this.orig_code = state.current.script.code
        if (state.current.script.default_input){
          state.current.input.send = true
          state.current.input.payload = state.current.script.default_input
        }
      }).catch((err)=>{
        console.log(err)
      })
    }
    if (!state.current.runs) {
      fetch(`/api/last_10_runs/${this.$route.params.id}`).then((res)=>{
        if (res.ok){ return res.json() }
      }).then((runs)=>{
        state.current.runs = runs
      }).catch((err)=>{
        console.log(err)
      })
    }
  },
  mixins: [Helpers],
  methods: {
    toggle_extensions_pane(){ this.show_extensions = !this.show_extensions },
    set_save_for_later(){ this.save_for_later=true; },
    undo(){ state.current.script.code = this.orig_code },
    save(){
      var status = null
      Vue.set(state.current, 'field_errors', {})
      fetch(`/api/scripts`, {
        method: 'POST',
        credentials: 'include',
        body: JSON.stringify(state.current.script)
      }).then(res => {
        status = res.status
        return res.json()
      }).then( data => {
        if (status >= 200 && status <= 299){
          senate.flash("Script saved")
          state.current.script = data.script
          this.orig_code = state.current.script.code
          this.$router.replace(`/scripts/${state.current.script.id}`)
        } else if (status == 400){
          senate.flash(data.message, "warning")
          Vue.set(state.current, 'field_errors', data.field_errors)
        }
      }).catch(err => {
        console.log(err)
      })
    },
    save_as_default_input(script_id, payload){
      fetch(`/api/scripts/${script_id}/set_default_input`, {
        method: 'POST',
        credentials: 'include',
        body: payload
      }).then(res => {
        if (res.ok){
          state.current.script.default_input = payload
        }
      }).catch(err => {
        console.log(err)
      })
    },
    add_trigger(){
      state.current.script.triggers.push(senate.new_trigger())
    },
    remove_trigger(trigger){
      var idx = state.current.script.triggers.indexOf(trigger)
      if (idx > -1){ state.current.script.triggers.splice(idx, 1) }
    },
    run(){
      var input = null
      if (state.current.input.send){
        input = state.current.input.payload
      }
      var payload = {
        code: state.current.script.code,
        input: input,
        extensions: state.current.script.extensions,
        script_id: state.current.script.id
      }
      this.running = true
      state.loading = true
      fetch(`/api/run`, {
        method: 'POST',
        credentials: 'include',
        body: JSON.stringify(payload)
      }).then(res => {
        this.running = false
        state.loading = false
        return res.json()
      }).then(output => {
        state.current.runs.unshift(output)
        if (output.error) {
          senate.flash("Script produced an error", "danger")
        }
      }).catch(err => {
        console.log(err)
        this.running = false
        state.loading = false
      })
    }
  }
}
</script>
<style lang="less" scoped>
@import '../styles/variables.less';
.extensions_toggle{ text-decoration: none; }
.left_panel{ width: 60%; box-sizing: border-box;padding: 1em; float: left; }
.right_panel{ width: 40%; box-sizing: border-box; padding: 1em; float: left; }
</style>
