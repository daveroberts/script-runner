import Vue from 'vue'
import VueRouter from 'vue-router'
Vue.use(VueRouter)

import Adhoc from './scripts/Adhoc.vue'
import SavedScripts from './scripts/SavedScripts.vue'
import Script from './scripts/Script.vue'
const routes = [
  { path: '/scripts', component: SavedScripts },
  { path: '/scripts/:id', component: Script },
  { path: '/adhoc', component: Adhoc },
]
const router = new VueRouter({routes})

export default router
