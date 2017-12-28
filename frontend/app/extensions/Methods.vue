<template>
  <div>
    <div v-for="(info, method) in class_info.methods">
      <span class="method_signature" :href="'#method_'+method"></span></span>
    </div>
    <table :class="['method_table',ruby?'ruby':'']">
      <thead>
        <tr>
          <th colspan="2"><a class="not_a_link" href="#" @click.prevent="ruby = !ruby">Method Summary</a></th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(info, method) in class_info.methods">
          <td><span v-if="info.returns">{{info.returns.name}}</span></td>
          <td>
            <div>
              <span class="method_signature">
                {{method}}({{info.params.map(p=>p.name).join(', ')}})
              </span>
            </div>
            <div class="inline_summary">{{info.summary}}</div>
          </td>
        </tr>
      </tbody>
    </table>
    <div v-for="(info, method) in class_info.methods">
      <h2>{{Method}}</h2>
        <span class="method_signature">
          {{method}}({{info.params.map(p=>p.name).join(', ')}})
        </span>
        <div>{{info.summary}}</div>
        <div style="font-weight: bold;">Parameters</div>
        <div v-for="param in info.params">
          <div class="param_line"><span class="param_name">{{param.name}}</span> - <span style="white-space: pre-wrap;">{{param.description}}</span></div>
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
  props: [ 'class_info' ],
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
.method_table, .method_table th, .method_table td{ border: 3px solid black; padding: 0.25em; }
.param_line{ text-indent: 2em; }
.param_name{ font-family: monospace; font-size: @font-size-small; }
.not_a_link{ text-decoration: none; }
.ruby > thead { background-color: #FFCCCC; }
.ruby > thead > tr > th > a { color: #700; }
.ruby, .ruby th, .ruby td{ border: 3px solid #700; }
.ruby .method_signature{ color: #700; }
</style>
