require "sinatra"
require "grit"
require "yaml"
require "fileutils"

options = YAML.load_file("config.yml")

def repo_name(repo_url)
  repo_url =~ /.*\/([\w-]+)/
  $1
end

def clone_repo(repo)
  FileUtils.rm_rf("tmp/repo")
  grit = Grit::Git.new("/tmp/filler")
  grit.clone({}, repo, "tmp/#{repo_name(repo)}")
  "cloned into #{repo_name(repo)}"
end

def build_repo(repo)
  `cd tmp/#{repo_name(repo)} && rake`
end

get "/" do
  options["repo"]
end

post "/clone" do
  clone_repo options["repo"]
end

post "/build" do
  build_repo options["repo"]
end
