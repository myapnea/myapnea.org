@ABSetupReady = () ->
  console.log "A/B setup ready"
  utmx 'url', 'A/B'
