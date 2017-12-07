<template>
  <div>
    <div class="nav-bar">
      <router-link class="nav-item" to="/scripts" exact>Saved Scripts</router-link>
      <router-link class="nav-item" to="/data-explorer" exact>Data Explorer</router-link>
    </div>
    <div style="padding: 1em;">
      <div id="alerts">
        <div v-for="alert in alerts">
          <div v-bind:class="['alert', `alert-${alert.type}`, alert.show?'visible':'']" role="alert">{{alert.msg}}</div>
        </div>
      </div>
      <router-view></router-view>
    </div>
  </div>
</template>
<script>
import state from './state/state.js'
export default {
  computed: {
    alerts: function(){ return state.alerts }
  },
  created: function(){
  },
  data: function(){
    return {
      state: state
    }
  },
  methods: {
  }
}
</script>
