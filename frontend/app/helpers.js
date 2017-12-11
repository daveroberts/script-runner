var helpers = {
  methods: {
    pretty_date(str){
      if (str == null){ return '' }
      var d = new Date(str.substring(0,4), str.substring(5,7)-1, str.substring(8,10), str.substring(11,13), str.substring(14,16), str.substring(17,19));
      const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
      var ampm = (d.getHours() >= 12) ? "PM" : "AM"
      var minutes = d.getMinutes()
      if (minutes < 10){ minutes = "0" + minutes }
      var seconds = d.getSeconds()
      if (seconds < 10){ seconds = "0" + seconds }
      return `${months[d.getMonth()]} ${d.getDate()+1}, ${d.getFullYear()} ${d.getHours()}:${minutes}:${seconds}`
    }
  }
}

export default helpers
