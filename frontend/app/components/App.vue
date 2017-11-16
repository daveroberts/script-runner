<template>
  <div>
    <div class="nav-bar">
      <router-link class="nav-item" v-if="current_user" to="/users" exact>User List</router-link><router-link class="nav-item" v-if="!current_user" to="/login" exact>Login</router-link><router-link class="nav-item" to="/info" exact>Info</router-link><a class="nav-item nav-item-right" href="#/login" v-on:click="logout()" v-if="current_user">Logout</a><span class="nav-item nav-item-right" v-if="current_user">{{ current_user.username }}</span>
    </div>
    <div style="padding: 1em;">
      <router-view></router-view>
    </div>
  </div>
</template>
<script>
import auth from '../services/AuthService.js'
export default {
  computed: {
    current_user(){ return this.$store.state.current_user }
  },
  created: function(){
    auth.check().then((res)=>{
      console.log("Resolved")
    }).catch((err)=>{
      console.log("Error")
    })
  },
  data: function(){
    return {
    }
  },
  methods: {
    "logout": function(){
      auth.logout().then((res)=>{
      }).catch((err)=>{
        console.log("err")
        console.dir(err)
      })
    }
  }
}
</script>
