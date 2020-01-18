# add cities to global variable
cities = YAML.load_file("lib/cities.yml")
roles = %w[superadmin user]
Object.const_set("CITIES", cities)
Object.const_set("ROLES", roles)
