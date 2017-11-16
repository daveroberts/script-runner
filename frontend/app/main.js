import './styles/reset.css'
import './styles/style.less'

import Vue from 'vue'
import VueRouter from 'vue-router'
Vue.use(VueRouter)
import VueCodeMirror from 'vue-codemirror'
Vue.use(VueCodeMirror)

import App from './components/App.vue'
import Users from './components/Users.vue'
import Info from './components/Info.vue'
import Script from './scripts/Script.vue'
const routes = [
  { path: '/users', component: Users },
  { path: '/info', component: Info },
  { path: '/scripts', component: Script },
]
const router = new VueRouter({routes})

var app = new Vue({
  el: '#app',
  render: h=>h(App),
  router: router
})
