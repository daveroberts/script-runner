const initial_state = {
  alerts: [
    /*{id: 4, msg: 'success', show: true, type: 'success'},
    {id: 5, msg: 'warning', show: true, type: 'warning'},
    {id: 6, msg: 'danger', show: true, type: 'danger'},*/
  ],
  tags: {
    current: null,
    data: null
  },
  sets: {
    current: null,
    data: null
  },
  dictionaries: {
    current: null,
    data: null
  },
  queues: {
    current: null,
    data: null
  },
  current: {
    script: {
      id: null,
      name: "",
      description: "",
      code: "",
      active: true,
      created_at: null,
      triggers: []
    },
    runs: null,
    input: {
      send: false,
      payload: ""
    }
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
