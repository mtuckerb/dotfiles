export def get_jwt [] {
 let jwt = ((op item get "Gocopia - Mission Control" --fields label=jwt))
 return ($"Bearer ($jwt)")
}


export def get [endpoint: string, params: string] {
  http get -H [Authorization (get_jwt)] $"https://mc.production.api.gocopia.com/($endpoint)?($params)"
}

export def put [endpoint: string, body: string] {
  http put -H [Authorization (get_jwt)] $"https://mc.production.api.gocopia.com/($endpoint)" $body
}
