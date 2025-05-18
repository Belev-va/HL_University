region        = "eu-west-2"
instance_name = "FlureBlog-wp"
instance_type = "micro_3_0"
app           = "wordpress"

tags = {
  product  = "flure"
  platform = "web"
}

ssh_key_paths = [
  "keys/dmitryovsianikov.pub",
  "keys/v.belev.pub",
  "keys/a.oskin.pub"
]
