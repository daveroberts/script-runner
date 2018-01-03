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
      category: "",
      description: "",
      default_input: null,
      code: "",
      trigger_cron: false,
      cron_every: 0,
      cron_last_run: null,
      cron_locked_at: null,
      trigger_queue: false,
      queue_name: "",
      trigger_http: false,
      http_method: 'GET',
      http_endpoint: '',
      http_request_content_type: '',
      http_response_content_type: '',
      created_at: null,
    },
    runs: null,
    field_errors: {},
    trace: {
      id: null,
      data: null
    },
    input: {
      type: 'MANUAL',
      payload: "",
      queue: ""
    },
  },
  list: null
}

export default initial_state
