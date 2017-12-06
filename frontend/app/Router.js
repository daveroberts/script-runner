import Vue from 'vue'
import VueRouter from 'vue-router'
Vue.use(VueRouter)

import SavedScripts from './scripts/SavedScripts.vue'
import Script from './scripts/Script.vue'
const routes = [
  { path: '/', component: SavedScripts },
  { path: '/scripts', component: SavedScripts },
  { path: '/scripts/:id', component: Script },
]
const router = new VueRouter({routes})

export default router
