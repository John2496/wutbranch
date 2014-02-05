require 'rake'

Gem::Specification.new do |s|
    s.name = 'wutbranch'
    s.version = '0.0.2'
    s.date = '2014-02-04'
    s.summary = "Console utility to display the current branch on remote servers."
    s.description = "Console utility to display the current branch on remote servers."
    s.authors = ["John Himmelman"]
    s.email = 'john2496@gmail.com'
    s.files = FileList["lib/*",
                "bin/*",
                "Gemfile",
                "config.yaml.example"]
    s.homepage = 'http://rubygems.org/gems/wutbranch'
    s.license = 'MIT'
end