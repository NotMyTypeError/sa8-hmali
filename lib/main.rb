# Git Repository System Demo
#
# This is a simplified model of how Git works internally.
# Real Git systems are much more complex and use different data structures.
#
# Basic Git concepts this demo illustrates:
# 1. Authors create commits with messages and timestamps
# 2. Repositories store commits and track branches
# 3. Branches can be created and switched between
# 4. Can view commit history on branches
#
# This system demonstrates core version control concepts.
# The demo shows two authors (Ava and Grace) making commits, creating and switching between branches, and viewing branch logs.

require_relative 'commit'
require_relative 'repository'
require_relative 'author'

repo = Repository.new
ada = Author.new("Ava","ava@example.org")
grace = Author.new("Grace","grace@example.org")

repo.commit!(message: "Init README", author: ada)
#ada adds a readme file to the repo

repo.create_branch("feature/docs")
repo.switch("feature/docs")
repo.commit!(message: "Add docs", author: grace)
# grace adds docs to a feature branch and makes a commit

repo.switch("main")
repo.commit!(message: "Tweak README", author: ada)
# ada switches back to main, then tweaks readme file

puts "Branches: #{repo.branches.keys.join(', ')}"
# prints all the existing branches

puts "main HEAD id:    #{repo.branch('main')}"
# prints main's hash

puts "feature HEAD id: #{repo.branch('feature/docs')}"
# prints the feature/doc branch's hash

puts "\nLog (main):"
repo.log("main").each { |c| puts " * #{c.id} #{c.message} (#{c.author.email})" }
# displays commit history of the main branch

puts "\nLog (feature/docs):"
repo.log("feature/docs").each { |c| puts " * #{c.id} #{c.message} (#{c.author.email})" }
# displays commit history of the feature/doc branch