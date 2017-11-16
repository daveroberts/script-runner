<template>
  <div>
    <h1>Login</h1>
    <div v-if="error" class="error">{{error}}</div>
    <form v-on:submit="login()">
      <table>
        <tbody>
          <tr>
            <td><label for="username">Username</label></td>
            <td><input id="username" type="text" v-model="user.username" /></td>
          </tr>
          <tr>
            <td><label for="password">Password</label></td>
            <td><input id="password" type="password" v-model="user.password" /></td>
          </tr>
          <tr>
            <td></td>
            <td><input type="submit" value="Login" /></td>
          </tr>
        </tbody>
      </table>
    </form>
  </div>
</template>
<script>
import auth from '../services/AuthService.js'
export default {
  data: function(){
    return {
      user: {username: '', password: ''},
      error: null
    }
  },
  methods: {
    "login": function(){
      var self = this
      self.error = null
      auth.login(self.user).then(function(u){
        self.$router.push({path: 'users'})
      }).catch(function(err){
        if (err.response.status == 422){
          self.error = err.response.data
        } else {
          console.dir(err)
        }
      })
    }
  }
}
</script>
<style>
.error{ background-color: #e23d31; color: white; padding: 10px; border-radius: 5px; }
</style>
