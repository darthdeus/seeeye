require "sinatra"
require "grit"
require "yaml"
require "fileutils"

options = YAML.load_file("config.yml")

def repo_name(repo_url)
  repo_url =~ /.*\/([\w-]+)/
  $1
end

class Repo
  attr_reader :url

  def initialize(url)
    @url = url
  end

  def clone(target_dir)
    clean_previous_clone(target_dir)

    grit = Grit::Git.new("/tmp/filler")
    grit.clone({}, url, "#{target_dir}/#{name}")
  end

  def build(target_dir)
    `cd #{target_dir}/#{name} && rake`
  end

  def name
    @url =~ /.*\/([\w-]+)/
    return $1
  end

  def clean_previous_clone(target_dir)
    FileUtils.rm_rf("#{target_dir}/#{name}")
  end
end

def clone_repo(repo_url)
  repo = Repo.new(repo_url)
  repo.clone("tmp")
  "cloned into #{repo.name}"
end

def build_repo(repo_url)
  repo = Repo.new(repo_url)
  repo.build("tmp")
end

get "/" do
  options["repo"]

  "<form action='/clone' method='post'><input type='submit' value='Clone'></form>" +
  "<form action='/build' method='post'><input type='submit' value='Build'></form>"
end

post "/clone" do
  clone_repo options["repo"]
end

post "/build" do
  build_repo options["repo"]
end
