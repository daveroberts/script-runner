import './styles/reset.css'
import './styles/style.less'

import Vue from 'vue'
import VueRouter from 'vue-router'
Vue.use(VueRouter)
import VueCodeMirror from 'vue-codemirror'
Vue.use(VueCodeMirror)

import App from './App.vue'
import Adhoc from './scripts/Adhoc.vue'
import SavedScripts from './scripts/SavedScripts.vue'
const routes = [
  { path: '/scripts', component: SavedScripts },
  { path: '/adhoc', component: Adhoc },
]
const router = new VueRouter({routes})

var app = new Vue({
  el: '#app',
  render: h=>h(App),
  router: router
})
