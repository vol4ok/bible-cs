require "colors"
exs = require "express"
ect = require "ect"
moment = require "moment"
fs = require "fs"

_ = require "lodash"
require("uasync")(_)

app = exs()

app
  .disable("x-powered-by")
  .set("view engine", "ect")
  .engine('ect', ect(
      root : __dirname + '/views'
      ext : '.ect'
      cache: no
    ).render)
  
app 
  .use(exs.bodyParser())
  .use(exs.logger("short"))
  .use(app.router)
  .use(exs.static("public"))
  .use (req, res) ->
    res.render("index")

db = {
  "books": [
    {
      "id": "mf",
      "name": "Евангелие от Матфея",
      "chapters": 28
    },
    {
      "id": "mk",
      "name": "Евангелие от Марка",
      "chapters": 16
    },
    {
      "id": "lk",
      "name": "Евангелие от Луки",
      "chapters": 24
    },
    {
      "id": "in",
      "name": "Евангелие от Иоанна",
      "chapters": 21
    },
    {
      "id": "ps",
      "name": "Псалтирь",
      "chapters": 151
    }
  ],
  "chapters": {
    "mf": JSON.parse(fs.readFileSync("data/mf.json").toString()),
    "mk": JSON.parse(fs.readFileSync("data/mk.json").toString()),
    "lk": JSON.parse(fs.readFileSync("data/lk.json").toString()),
    "in": JSON.parse(fs.readFileSync("data/in.json").toString()),
    "ps": JSON.parse(fs.readFileSync("data/ps.json").toString())
  }
}

app.get '/data/books', (req, res) ->
  res.json(db.books)

app.get '/data/chapters/:bookId', (req, res) ->
  if req.params.bookId and db.chapters[req.params.bookId]
    res.json(db.chapters[req.params.bookId])
  else
    res.send(500)


port = process.env.PORT || 8888
app.listen(port)
console.log "start server on port #{port}".green