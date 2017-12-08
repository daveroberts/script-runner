import Vue from 'vue'
import VueRouter from 'vue-router'
Vue.use(VueRouter)

import SavedScripts from './scripts/SavedScripts.vue'
import Script from './scripts/Script.vue'
import DataExplorer from './data/Explorer.vue'
import Dictionary from './data/Dictionary.vue'
import Queue from './data/Queue.vue'
const routes = [
  { path: '/', component: SavedScripts },
  { path: '/scripts', component: SavedScripts },
  { path: '/scripts/:id', component: Script },
  { path: '/data-explorer', component: DataExplorer },
  { path: '/dictionaries/:name', component: Dictionary },
  { path: '/queues/:name', component: Queue },
]
const router = new VueRouter({routes})

export default router
