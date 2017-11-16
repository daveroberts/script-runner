<template>
  <div>
    <h1>Users</h1>
    <div v-if="users">
      <table class="table">
        <thead>
          <tr>
            <th>Name</th>
            <th>Age</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="user in users">
            <td>{{user.name}}</td>
            <td>{{user.age}}</td>
            <td><a class="btn btn-icon" href="#" v-on:click.prevent="remove(user)"><i class="fa fa-trash" aria-hidden="true"></i></a></td>
          </tr>
        </tbody>
      </table>
    </div>
    <div>
      <h2>Add a new user</h2>
      <form v-on:submit.prevent="create_user" class="form">
        <table>
          <tbody>
            <tr>
              <th><label for="username">Username</label></th>
              <td><input type="text" ref="username" id="username" v-model="new_user.name" /></td>
            </tr>
            <tr>
              <th><label for="age">Age</label></th>
              <td><input type="number" id="age" v-model="new_user.age" /></td>
            </tr>
            <tr>
              <th></th>
              <td><button class="btn" type="submit"><i class="fa fa-plus-circle" aria-hidden="true"></i> Create User</button></td>
            </tr>
          </tbody>
        </table>
      </form>
    </div>
  </div>
</template>
<script>
import state from '../state/state.js'
export default {
  computed: {
    users(){ return state.users }
  },
  created: function(){
  },
  data: function(){
    return {
      new_user: {name: '', age: ''}
    }
  },
  methods: {
    "remove": function(user){
    },
    "create_user": function(){
    }
  }
}
</script>
<style>
tbody tr{ line-height: 2em; }
</style>
