const initial_state = {
  loading: false,
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
  extensions: {
    list: null,
    last_loaded: null
  },
  current: {
    script: {
      id: null,
      name: "",
      description: "",
      default_input: null,
      extensions: [],
      code: "",
      active: true,
      created_at: null,
      triggers: []
    },
    runs: null,
    field_errors: {},
    input: {
      type: 'NONE',
      payload: "",
      queue: ""
    },
  },
  list: null,
  blank: {
    trigger: {
      script_id: null,
      type: 'CRON',
      active: true,
      every: 10,
      queue_name: '',
      http_endpoint: '',
      http_method: 'GET',
      created_at: null
    }
  }
}

export default initial_state
