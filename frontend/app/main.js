import './styles/reset.css'
import './styles/style.less'

import Vue from 'vue'
import VueCodeMirror from 'vue-codemirror'
import 'codemirror/lib/codemirror.css'
import 'codemirror/mode/clojure/clojure.js'
import 'codemirror/theme/mdn-like.css'
Vue.use(VueCodeMirror)

import router from './Router.js'
import App from './App.vue'

var app = new Vue({
  el: '#app',
  render: h=>h(App),
  router: router
})
