<template>
  <div>
    <div v-if="script">
      <div class="outer">
        <div class="left_panel">
          <h1 v-if="script.name">{{script.name}}</h1>
          <h1 v-else>Code</h1>
          <div id="input_section" style="margin-bottom: 0.25em;">
            <div>
              <a class="not_a_link" href="#" @click.prevent="show_input = !show_input">
                <span>Script Test Input</span>
                <span v-if="!show_input">
                  <i class="fa fa-caret-right" aria-hidden="true"></i>
                </span>
                <span v-else>
                  <i class="fa fa-caret-down" aria-hidden="true"></i>
                </span>
              </a>
            </div>
            <div v-if="show_input" id="input_buttons_and_dials">
              <div style="margin: 0.25em 0;">
                <select v-model="state.current.input.type">
                  <option value="NONE">No input</option>
                  <option value="MANUAL">Typed input</option>
                  <option value="QUEUE">Pull input from queue</option>
                </select>
              </div>
              <div v-if="state.current.input.type == 'MANUAL'">
                <div class="code_editor">
                  <codemirror v-model="state.current.input.payload" :options="editorOptions"></codemirror>
                </div>
                <div v-if="script.id && state.current.input.payload && state.current.input.payload != script.default_input"><button type="button" class="btn btn-small" @click="save_as_default_input(script.id, state.current.input.payload)"><i class="fa fa-save" aria-hidden="true"></i> Save as default test input</button></div>
              </div>
              <div v-if="state.current.input.type == 'QUEUE'">
                <label for="current_input_queue">Queue:</label>
                <input id="current_input_queue" type="text" v-model="state.current.input.queue" />
              </div>
            </div>
          </div>
          <div class="code_editor">
            <codemirror v-model="script.code" :options="editorOptions"></codemirror>
          </div>
          <div v-if="!script.id && script.code && runs && runs.length" style="margin: 0;" class="warning">This script has not yet been saved.</div>
          <div v-if="script.id && script.code != orig_code">
            <button type="button" class="btn btn-small" @click.prevent="save()"> <i class="fa fa-floppy-o" aria-hidden="true"></i> Save Changes</button>
            <button type="button" class="btn btn-danger btn-small" @click.prevent="undo()"> <i class="fa fa-undo" aria-hidden="true"></i> Undo Changes</button>
          </div>
          <div style="margin: 0.5em 0;">
            <button :class="['btn', running?'btn-disabled':'']" :disabled="running" @click="run()">
              <span v-if="!running"><i class="fa fa-circle-o-notch" aria-hidden="true"></i> Run</span>
              <span v-else><i class="fa fa-circle-o-notch fa-spin"></i></i> Running Code</span>
            </button>
          </div>
        </div>
        <div class="right_panel">
          <div v-if="last_run">
            <div>
              <h1>Run Details</h1>
              <!--a href="#" @click.prevent="show_run_details = !show_run_details">
                <span v-if="show_run_details">Hide Run Details</span>
                <span v-else>Show Run Details</span>
              </a-->
              <div v-if="show_run_details">
                <!--div>
                  <div class="fancy_checkbox">
                    <input id="show_run_details_debug" type="checkbox" v-model="show_run_details_debug" />
                    <label for="show_run_details_debug"></label>
                  </div>
                  <label class="fancy_checkbox_label" for="show_run_details_debug">Show low level debug messages?</label>
                </div-->
                <input type="checkbox" name="show_run_details_switch" id="show_run_details_switch" v-model="show_run_details_debug">
                <label class="small" for="show_run_details_switch">Show low level debug details</label>
                <div class="debug_output" v-if="msg.level != 'debug' || show_run_details_debug" v-for="msg in state.current.trace.data">
                  {{msg.summary}}
                  <span v-if="msg.tables">
                    <a href="#" @click.prevent="msg.show_tables = !msg.show_tables">
                      <span v-if="msg.show_tables">&lt;&lt;</span>
                      <span v-else>&gt;&gt;</span>
                    </a>
                  </span>
                  <div v-if="msg.show_tables">
                    <div v-for="table in msg.tables">
                      <div>{{table.title}}</div>
                      <table class="mini_table">
                        <thead>
                          <tr>
                            <th v-for="header in table.headers">
                              {{header.name}}
                            </th>
                          </tr>
                        </thead>
                        <tbody>
                          <tr v-for="row in table.rows">
                            <td v-for="cell in row">
                              {{cell.value}}
                            </td>
                          </tr>
                        </tbody>
                      </table>
                    </div>
                  </div>
                  <span v-if="msg.image_id">
                    <a href="#" @click.prevent="msg.show_image = !msg.show_image">
                      <span v-if="msg.show_image">&lt;&lt;</span>
                      <span v-else>&gt;&gt;</span>
                    </a>
                  </span>
                  <div v-if="msg.show_image">
                    <a target="_blank" :href="'/api/images/'+msg.image_id">
                      <img class="image_preview" :src="'/api/images/'+msg.image_id+'/thumbnail'" alt="thumbnail" />
                    </a>
                  </div>
                </div>
              </div>
            </div>
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
            <span><i class="fa fa-pencil" aria-hidden="true"></i> Edit Script</span>
            <span style="display: inline-block; width: 0.5em;" v-if="show_script_details"><i class="fa fa-caret-down" aria-hidden="true"></i></span>
            <span style="display: inline-block; width: 0.5em;" v-else><i class="fa fa-caret-right" aria-hidden="true"></i></span>
          </a>
        </h2>        
        <form v-if="show_script_details" @submit.prevent="save()">
          <table>
            <tbody class="form_section">
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
                  <textarea style="width: 100%; box-sizing: border-box;" v-model="script.description"></textarea>
                </td>
              </tr>
            </tbody>
            <tbody class="form_section">
              <tr class="form_row">
                <th class="form_label">Run script on a timer</th>
                <td>
                  <div class="onoffswitch">
                    <input type="checkbox" name="trigger_cron_switch" class="onoffswitch-checkbox" id="trigger_cron_switch" v-model="script.trigger_cron">
                    <label class="onoffswitch-label" for="trigger_cron_switch"></label>
                  </div>
                </td>
              </tr>
              <tr v-if="script.trigger_cron" class="form_row">
                <th class="form_label">Every</th>
                <td>
                  <span><input type="number" style="width: 4em;" v-model="script.cron_every" /> minutes</span>
                </td>
              </tr>
              <tr class="form_row" v-if="script.trigger_cron">
                <th class="form_label">Last Auto Run</th>
                <td>
                  <span v-if="script.cron_last_run">{{pretty_date(script.cron_last_run)}}</span>
                  <span v-else>Script has never been triggered</span>
                </td>
              </tr>
            </tbody>
            <tbody class="form_section">
              <tr class="form_row">
                <th class="form_label">Run script when item added to queue</th>
                <td>
                  <div class="onoffswitch">
                    <input type="checkbox" name="trigger_queue_switch" class="onoffswitch-checkbox" id="trigger_queue_switch" v-model="script.trigger_queue">
                    <label class="onoffswitch-label" for="trigger_queue_switch"></label>
                  </div>
                </td>
              </tr>
              <tr class="form_row" v-if="script.trigger_queue">
                <th class="form_label">Queue Name</th>
                <td>
                  <input type="text" v-model="script.queue_name" />
                </td>
              </tr>
              <tr class="form_row" v-if="script.queue_name">
                <th class="form_label"></th>
                <td>Inspect <a target="_blank" :href="'/#/queues/'+script.queue_name">{{script.queue_name}}</a> queue</td>
              </tr>
            </tbody>
            <tbody class="form_section">
              <tr class="form_row">
                <th class="form_label">Run script via HTTP</th>
                <td>
                  <div class="onoffswitch">
                    <input type="checkbox" name="trigger_http_switch" class="onoffswitch-checkbox" id="trigger_http_switch" v-model="script.trigger_http">
                    <label class="onoffswitch-label" for="trigger_http_switch"></label>
                  </div>
                </td>
              </tr>
              <tr class="form_row" v-if="script.trigger_http">
                <th class="form_label">HTTP Method</th>
                <td>
                  <select v-model="script.http_method">
                    <option v-for="type in method_types" v-bind:value="type">{{type}}</option>
                  </select>
                  
                </td>
              </tr>
              <tr class="form_row" v-if="script.trigger_http">
                <th class="form_label">HTTP Endpoint</th>
                <td>
                  <input type="text" v-model="script.http_endpoint" />
                </td>
              </tr>
              <tr class="form_row" v-if="script.trigger_http && script.http_method == 'POST'">
                <th class="form_label">HTTP Request Content Type</th>
                <td>
                  <input type="text" placeholder="application/json" v-model="script.http_request_content_type" />
                </td>
              </tr>
              <tr class="form_row" v-if="script.trigger_http">
                <th class="form_label">HTTP Response Content Type</th>
                <td>
                  <input type="text" placeholder="application/json" v-model="script.http_response_content_type" />
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
        <div v-if="!script.id && !save_for_later">
          <button class="btn" @click="save_for_later = true; show_script_details = true"><i class="fa fa-save" aria-hidden="true"></i> Save Script</button>
        </div>
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
                <th>Runtime (seconds)</th>
                <th style="text-align: right;">Run</th>
              </tr>
            </thead>
            <tbody v-if="runs.length == 0">
              <tr>
                <td colspan="3" style="text-align: center; font-style: italic; padding: 1em;">Script has not yet been run</td>
              </tr>
            </tbody>
            <tbody v-else>
              <tr v-for="run in runs">
                <td style="font-size: 10pt;">
                  <pre class="json" v-if="run.output != null" v-html="syntax_highlight(run.output)"></pre>
                  <pre class="monospace error" v-if="run.error">{{run.error}}</pre>
                </td>
                <td>{{run.seconds_running}}</td>
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
import MethodSummary from '../extensions/MethodSummary.vue'
import Helpers from '../helpers.js'
const loadExtensions = (time = new Date()) => {
  fetch(`/api/extensions/`, {
    credentials: 'include'
  }).then(res => {
    if (res.ok){ return res.json() }
  }).then(extensions => {
    state.extensions.list = extensions
  }).catch(err => {
    console.log(err)
  })
}
export default {
  data: function(){
    return {
      state: state,
      show_input: false,
      show_run_details: true,
      show_run_details_debug: false,
      save_for_later: false,
      orig_code: '',
      method_types: ['GET', 'POST'],
      show_extensions: false,
      show_script_details: false,
      running: false,
      editorOptions: {
        tabSize: 2,
        mode: {
          name: 'jslike',
          json: true
        },
        theme: 'js-like',
        lineNumbers: true,
        line: true,
        smartIndent: false
      }
    }
  },
  components: { MethodSummary },
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
      state.current.input.type = 'MANUAL'
      state.current.input.payload = state.current.script.default_input
    }
    if (state.current.script.code){ this.orig_code = state.current.script.code }
    if (!state.current.script || (state.current.script.id != this.$route.params.id) && this.$route.params.id != 'new') {
      state.current = JSON.parse(JSON.stringify(initial.current))
      fetch(`/api/scripts/${this.$route.params.id}`, {
         credentials: 'include'
    }).then((res)=>{
        if (res.ok){ return res.json() }
      }).then((script)=>{
        state.current.script = script
        this.orig_code = state.current.script.code
        if (state.current.script.default_input){
          state.current.input.type = 'MANUAL'
          state.current.input.payload = state.current.script.default_input
        }
      }).catch((err)=>{
        console.log(err)
      })
    }
    if (!state.current.runs) {
      fetch(`/api/last_10_runs/${this.$route.params.id}`, {
         credentials: 'include'
    }).then( res => {
        if (res.ok){ return res.json() }
      }).then( runs => {
        state.current.runs = runs
      }).catch( err =>{
        console.log(err)
      })
    }
  },
  mixins: [Helpers],
  methods: {
    toggle_extensions_pane(){ this.show_extensions = !this.show_extensions },
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
          this.show_script_details = false
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
        body: JSON.stringify(payload)
      }).then(res => {
        if (res.ok){
          state.current.script.default_input = payload
        }
      }).catch(err => {
        console.log(err)
      })
    },
    run(){
      var input = null
      if (state.current.input.type == 'MANUAL'){
        input = state.current.input.payload
      }
      state.current.trace.id = Math.floor(Math.random() * 999999)
      state.current.trace.data = null
      var payload = {
        code: state.current.script.code,
        input: input,
        extensions: state.current.script.extensions,
        trace_id: state.current.trace.id,
        script_id: state.current.script.id
      }
      this.running = true
      state.loading = true
      //var get_traces_timer = setTimeout(() =>{
      var get_traces_timer = setInterval(() =>{
        fetch(`/api/traces/${state.current.trace.id}`, {
          credentials: "include"
        }).then(res => {
          return res.json()
        }).then(trace_data => {
          state.current.trace.data = trace_data
        }).catch(err => {
          console.log("Error getting trace data")
          console.log(err)
        })
      }, 1000)
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
        // wait 2 seconds, then stop grabbing updates
        setTimeout(() => {
          clearInterval(get_traces_timer)
        }, 2000)
      }).catch(err => {
        console.log(err)
        this.running = false
        state.loading = false
        clearInterval(get_traces_timer)
      })
    }
  }
}
</script>
<style lang="less" scoped>
@import '../styles/variables.less';
.extensions_toggle{ text-decoration: none; }
.left_panel{ width: 60%; box-sizing: border-box; padding-right: 0.5em; float: left; }
.right_panel{ width: 40%; box-sizing: border-box; padding-left: 0.5em; float: left; }
</style>
