<template>
  <div>
    <div class="method_line" v-for="(info, name) in methods">
      <span class="method_signature">{{name}}({{info.params.join(', ')}})</span><span class="method_description" v-if="info.description"> - {{info.description}}</span>
    </div>
  </div>
</template>
<script>
export default {
  data: function(){
    return {
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
</style>
