<template>
  <div>
    <div v-for="(info, method) in methods">
      <span class="method_signature">{{method}}({{info.params.map(p=>p.name).join(', ')}})</span><span v-if="info.summary"> - {{info.summary}}</span>
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
  props: [ 'methods' ],
  created: function(){
  },
  methods: {
  }
}
</script>
<style lang="less" scoped>
@import '../styles/variables.less';
.method_signature{ line-height: 1.3em; color: @base; font-family: monospace; font-weight: bold; }
</style>
