express = require('express')
watchr  = require('watchr')
exec    = require('child_process').exec
fs      = require('fs')
http    = require('http')
app     = express()


ips       = fs.readFileSync('ips.example').toString().split("\n")
locations = []

getJson = (url, callback) ->
  http.get url, (res) ->
    buffer = ""
    res.on 'data', (chunk) -> buffer += chunk
    res.on 'end', -> callback JSON.parse(buffer)

getNextLocation = ->
  ip = ips.pop()
  return false unless ip?

  getJson "http://www.geoplugin.net/json.gp?ip=#{ip}", (geoData) ->
    return unless geoData.geoplugin_status == 200
    locations.push 
      lat: Number geoData.geoplugin_latitude
      lon: Number geoData.geoplugin_longitude
  true

app.use express.static("#{__dirname}/public")

app.get '/update', (req, res) ->
  res.json locations
  locations = []

app.listen 3001

watchr.watch
  paths: ['app', null], # watchr has a bug where the last item in the array is ignored
  listener: (eventName, filePath, fileCurrentStat, filePreviousStat) ->
    if filePath.indexOf('.coffee') > -1
      exec "coffee -c -o public #{filePath}", (error, stdout, stderr) ->
        if error?
          console.log "#{stderr}"
        else
          console.log "compiled #{filePath}"

updater = setInterval ->
  unless getNextLocation()
    clearInterval updater
    console.log 'no more ips'
, 1200

console.log 'server started ...'