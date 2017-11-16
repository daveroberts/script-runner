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
  data: function(){
    return {
      state: state,
      new_user: {name: '', age: ''}
    }
  },
  computed: {
    users(){ return state.users }
  },
  created: function(){
    fetch(`/api/users/`).then(res => {
      if (res.ok){ return res.json() }
    }).then(users => {
      state.users = users
    }).catch(err => {
      console.log(err)
    })
  },
  methods: {
    "remove": function(user){
      var id = user.id
      fetch(`/api/users/${id}`, {
        method: "DELETE"
      }).then(res => {
        var idx = state.users.findIndex( u => u.id==id )
        state.users.splice(idx, 1)
      }).catch(err => {
        console.log(err)
      })
    },
    "create_user": function(){
      var self = this
      fetch(`/api/users`, {
        method: 'POST',
        body: JSON.stringify(this.new_user)
      }).then(res => {
        if (res.ok){ return res.json() }
      }).then(user => {
        state.users.push(user)
        self.new_user =  {name: '', age: ''}
      }).catch(err => {
        console.log(err)
      })
    }
  }
}
</script>
<style>
tbody tr{ line-height: 2em; }
</style>
