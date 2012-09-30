require "sinatra"
require "yaml"

options = YAML.load_file("config.yml")

def clone_repo(repo)
  system("git clone #{repo} tmp/#{repo}")
end

get "/" do
  options["repos"].join "\n"
end

post "/" do
  options["repos"].each do |repo|
    clone_repo repo
  end

  "all repositories were cloned"
end

