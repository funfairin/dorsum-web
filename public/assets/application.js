(function() {
  const arrivals = document.getElementById('arrivals')
  const template = document.getElementById('arrival')
  const offset = new Date().getTimezoneOffset()
  const event_source = new EventSource("https://" + window.location.hostname + "/" + window.location.pathname.split("/").at(-1) + window.location.search)
  event_source.addEventListener('arrival', (event) => {
    const data = JSON.parse(event.data)
    const arrival = template.content.cloneNode(true)
    arrival.querySelectorAll('a').forEach((element) => {
      if (data['color']) element.style.color = data['color']
      element.appendChild(document.createTextNode(' '))
      element.appendChild(document.createTextNode(data['display-name']))
      element.href = "?last-event-id=" + event.lastEventId
    })
    if (data['arrived-at']) {
      var arrival_at = new Date(parseInt(data['arrived-at']))
      arrival_at = new Date(arrival_at - arrival_at.getTimezoneOffset() - offset)
      arrival.querySelectorAll('span').forEach((element) => {
        element.appendChild(document.createTextNode(
          arrival_at.toLocaleTimeString('en-US', { hour: '2-digit', minute:'2-digit' })
        ))
      })
    }
    arrivals.appendChild(arrival)
  })
})()
