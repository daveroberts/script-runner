import Vue from 'vue'
import VueRouter from 'vue-router'
Vue.use(VueRouter)

import SavedScripts from './scripts/SavedScripts.vue'
import Script from './scripts/Script.vue'
import DataExplorer from './data/Explorer.vue'
import Dictionary from './data/Dictionary.vue'
import Queue from './data/Queue.vue'
import Set from './data/Set.vue'
import Tag from './data/Tag.vue'
import Extensions from './extensions/List.vue'
const routes = [
  { path: '/', component: SavedScripts },
  { path: '/scripts', component: SavedScripts },
  { path: '/scripts/:id', component: Script },
  { path: '/data-explorer', component: DataExplorer },
  { path: '/dictionaries/:name', component: Dictionary },
  { path: '/queues/:name', component: Queue },
  { path: '/sets/:name', component: Set },
  { path: '/tags/:name', component: Tag },
  { path: '/extensions', component: Extensions },
]
const router = new VueRouter({routes})

import state from './state/state.js'

router.beforeEach((to, from, next)=>{
  console.log(to)
  console.log(from)
  if (from.path == '/scripts/new' && state.current.script.code){
    var re = /\/scripts\/.+/
    if(re.exec(to.path)){ next(); return; }
    if (confirm("You haven't saved your script, are you sure?")){ next() }
  } else {
    next()
  }
})

export default router
