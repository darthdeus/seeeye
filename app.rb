require "sinatra"
require "grit"
require "yaml"
require "fileutils"

options = YAML.load_file("config.yml")

def clone_repo(repo)
  FileUtils.rm_rf("tmp/repo")
  grit = Grit::Git.new("/tmp/filler")
  grit.clone({}, repo, "tmp/repo")
end

def build_repo(repo)
  `cd tmp/repo && rake`
end

get "/" do
  options["repos"].join "\n"
end

post "/clone" do
  options["repos"].each do |repo|
    clone_repo repo
  end

  "all repositories were cloned"
end

post "/build/:repo" do |repo|
  build_repo repo
end
