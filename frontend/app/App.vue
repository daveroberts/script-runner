<template>
  <div>
    <div class="nav-bar">
      <router-link class="nav-item" to="/adhoc" exact>Adhoc</router-link>
      <router-link class="nav-item" to="/scripts" exact>Saved Scripts</router-link>
    </div>
    <div style="padding: 1em;">
      <router-view></router-view>
    </div>
  </div>
</template>
<script>
export default {
  computed: {
  },
  created: function(){
  },
  data: function(){
    return {
    }
  },
  methods: {
  }
}
</script>
