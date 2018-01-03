<template>
  <div>
    <div class="nav-bar">
      <router-link class="nav-item" to="/scripts" exact><i class="fa fa-th-large" aria-hidden="true"></i> Scripts</router-link><router-link class="nav-item" to="/data-explorer" exact><i class="fa fa-search" aria-hidden="true"></i> Data Explorer</router-link><router-link class="nav-item" to="/extensions" exact><i class="fa fa-cogs" aria-hidden="true"></i> Extensions</router-link>
    </div>
    <div v-if="loading" class="progress-line"></div>
    <div style="padding: 1em;">
      <div id="alerts">
        <div v-for="alert in alerts">
          <div v-bind:class="['alert', `alert-${alert.type}`, alert.show?'visible':'alert-gone']" role="alert">
            {{alert.msg}}
            <a href="#" @click.prevent="close_alert(alert)" class="alert-close"><i class="fa fa-times" aria-hidden="true"></i></a>
          </div>
        </div>
      </div>
      <router-view></router-view>
    </div>
  </div>
</template>
<script>
import state from './state/state.js'
import * as senate from './state'
export default {
  computed: {
    alerts: function(){ return state.alerts },
    loading: function(){ return state.loading }
  },
  created: function(){
  },
  data: function(){
    return {
      state: state,
      SETTINGS: SETTINGS
    }
  },
  methods: {
    close_alert(al){ senate.close_alert(al.id) }
  }
}
</script>
<style lang="less" scoped>
@import './styles/variables.less';
</style>
