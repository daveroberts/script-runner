const initial_state = {
  alerts: [
    /*{id: 4, msg: 'success', show: true, type: 'success'},
    {id: 5, msg: 'warning', show: true, type: 'warning'},
    {id: 6, msg: 'danger', show: true, type: 'danger'},*/
  ],
  current: {
    script: null,
    runs: null
  },
  adhoc: {
    input: {
      send: false,
      payload: ""
    },
    code: "",
    history: [
    ]
  },
  list: null,
  blank: {
    trigger: {
      script_id: null,
      type: 'CRON',
      active: true,
      every: 10,
      queue_name: '',
      created_at: null
    }
  }
}

export default initial_state
