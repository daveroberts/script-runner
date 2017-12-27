<template>
  <div>
    <div v-for="(args, method) in params">
      <span class="method_signature" :href="'#method_'+method">{{method}}({{args.join(', ')}})</span></span>
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
  props: [ 'params' ],
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
