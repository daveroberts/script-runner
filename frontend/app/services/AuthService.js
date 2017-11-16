import axios from 'axios'
import store from '../store'

class AuthService {
  login(user){
    return axios.post('/api/session', user).then((res)=>{
      const user = res.data
      store.commit('login', user)
      return user
    })
  }
  check(user){
    if (store.state.current_user){ return }
    return axios.get('/api/session', user).then((res)=>{
      const user = res.data
      store.commit('login', user)
      return user
    })
  }
  logout(){
    return axios.delete('/api/session').then((res)=>{
      store.commit('logout')
      return
    }).catch((err)=>{
      console.log(err)
    })
  }
}

module.exports = new AuthService()
