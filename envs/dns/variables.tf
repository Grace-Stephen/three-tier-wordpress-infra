variable "domains" {
  type = map(string)

  default = {
    staging = "staging.ogomawoman.store"
    prod    = "ogomawoman.store"
  }
}
