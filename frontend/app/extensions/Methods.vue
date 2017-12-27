<template>
  <div>
    <table :class="['method_table',ruby?'ruby':'']">
      <thead>
        <tr>
          <th colspan="2"><a class="not_a_link" href="#" @click.prevent="ruby = !ruby">Method Summary</a></th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(info, name) in methods">
          <td><span v-if="info.doc.returns">{{info.doc.returns.name}}</span></td>
          <td>
            <div>
              <span class="method_signature" :href="'#method_'+name"><span v-if="prefix">{{prefix}}.</span>{{name}}({{info.params.join(', ')}})</span></span>
            </div>
            <div class="inline_summary">{{info.summary}}</div>
          </td>
        </tr>
      </tbody>
    </table>
    <div v-for="(info, name) in methods">
      <h2><span v-if="prefix">{{prefix}}.</span>{{name}}</h2>
      <div class="method_signature" :href="'#method_'+name"><span v-if="prefix">{{prefix}}.</span>{{name}}({{info.params.join(', ')}})</span></div>
      <div v-if="info.doc">
        <div>{{info.doc.summary}}</div>
        <h3>Parameters</h3>
        <div v-for="param in info.doc.params">
          <div class="param_line"><span class="param_name">{{param.name}}</span> - <span>{{param.description}}</span></div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
export default {
  data: function(){
    return {
      ruby: false
    }
  },
  computed: {
  },
  props: [ 'methods', 'prefix' ],
  created: function(){
  },
  methods: {
  }
}
</script>
<style lang="less" scoped>
@import '../styles/variables.less';
.inline_summary{ text-indent: 3em; }
.method_signature{ color: @base; font-family: monospace; font-weight: bold; }
.method_description{ }
.method_table{ width: 100%; line-height: 1.5em; font-family: serif; }
.method_table > thead { background-color: #CCCCFF; font-size: @font-size-large; text-align: left; font-weight: bold; }
.ruby > thead { background-color: #FFCCCC; }
.method_table, .method_table th, .method_table td{ border: 3px solid black; padding: 0.25em; }
.param_line{ text-indent: 2em; }
.param_name{ font-family: monospace; font-size: @font-size-small; }
.not_a_link{ text-decoration: none; }
</style>
