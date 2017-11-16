export const increment = state => {
  state.count++
  state.history.push('increment')
}

export const decrement = state => {
  state.count--
  state.history.push('decrement')
}

export const setUsers = (state, users) => {
  state.users = users
  state.history.push('setUsers')
}

export const addUser = (state, user) => {
  state.users.push(user)
  state.history.push('addUser')
}

export const removeUser = (state, id) => {
  var idx = state.users.findIndex((u)=>u.id==id)
  if (idx > -1){ state.users.splice(idx,1) }
  state.history.push('removeUser')
}

export const login = (state, user) => {
  state.current_user = user
  state.history.push('login')
}

export const logout = state => {
  state.current_user = null
  state.history.push('logout')
}
