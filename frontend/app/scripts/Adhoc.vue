<template>
  <div>
    <h1>Script Runner</h1>
    <div v-if="error">{{ error }}</div>
    <div class="code_editor">
      <codemirror v-model="state.scripts.current" :options="editorOptions"></codemirror>
    </div>
    <div style="margin: 1em 0;">
      <button class="btn" @click="run()">Do it</button>
    </div>
    <div v-if="output">
      <h2>Script Run</h2>
      <pre>{{ most_recent.script }}</pre>
      <h2>Output</h2>
      <pre class="output json" v-html="prettyJson"></pre>
    </div>
    <h2>History</h2>
    <!-- TODO -->
    <pre>{{ state.scripts }}</pre>
  </div>
</template>
<script>
import state from '../state/state.js'
export default {
  data: function(){
    return {
      state: state,
      editorOptions: {
        tabSize: 2,
        mode: 'text/javascript',
        lineNumbers: true,
        line: true,
      }
    }
  },
  computed: {
    most_recent: function(){
      if (state.scripts.history.length == 0){ return null }
      return state.scripts.history[state.scripts.history.length - 1]
    },
    error: function(){
      if (!this.most_recent){ return null }
      if (this.most_recent.status != 'error'){ return null }
      return this.most_recent.error
    },
    output: function(){
      if (!this.most_recent){ return null }
      if (this.most_recent.status != 'ok'){ return null }
      return this.most_recent.output
    },
     prettyJson: function(){
      var value = this.output
      let json = JSON.stringify(value, null, 2)
      json = json.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')
      return json.replace(/("(\\u[a-zA-Z0-9]{4}|\\[^u]|[^\\"])*"(\s*:)?|\b(true|false|null)\b|-?\d+(?:\.\d*)?(?:[eE][+]?\d+)?)/g, function(match) {
        var cls = 'number'
        if (/^"/.test(match)) {
          if (/:$/.test(match)) {
            cls = 'key'
          } else {
            cls = 'string'
          }
        } else if (/true|false/.test(match)) {
          cls = 'boolean'
        } else if (/null/.test(match)) {
          cls = 'null'
        }
        return '<span class="' + cls + '">' + match + '</span>'
      })
    }
  },
  created: function(){
  },
  methods: {
    "run": function(){
      fetch(`/api/run`, {
        method: 'POST',
        body: state.scripts.current
      }).then(res => {
        return res.json()
      }).then(output => {
        state.scripts.history.push(output)
      }).catch(err => {
        console.log(err)
      })
    }
  }
}
</script>
<style>
.code_editor{ border: 1px solid #666; }
.CodeMirror{ height: auto; }
</style>
