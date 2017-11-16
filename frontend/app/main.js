import './styles/reset.css'
import './styles/style.less'

import Vue from 'vue'
import VueRouter from 'vue-router'
Vue.use(VueRouter)

import App from './components/App.vue'
import store from './store'
import Users from './components/Users.vue'
import Info from './components/Info.vue'
import Login from './components/Login.vue'
const routes = [
  { path: '/users', component: Users },
  { path: '/login', component: Login },
  { path: '/info', component: Info },
]
const router = new VueRouter({routes})

var app = new Vue({
  el: '#app',
  store: store,
  render: h=>h(App),
  router: router
})
