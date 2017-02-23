#!/usr/bin/env ruby

require "yaml"
require "open-uri"
require "digest"
require "docker"

baseURL = "http://dl-cdn.alpinelinux.org/alpine/latest-stable/releases/armhf/"

releases = open("#{baseURL}latest-releases.yaml") do |content|
	content.read # get YAML content
end

releases = YAML.load(releases) # parse file

minirootfs = releases.find do |item|
	item["flavor"] == "alpine-minirootfs" # find the minirootfs variant
end

puts "Latest Alpine Linux Mini Root FS: v#{minirootfs['version']} (#{minirootfs['date']})"

IO.copy_stream(open("#{baseURL}#{minirootfs['file']}"), minirootfs["file"]) # download file
checksum = Digest::SHA256.hexdigest(open(minirootfs["file"]).read)

if checksum == minirootfs["sha256"]
	# matched
	if Docker::Image.exist?('alpine:armhf') # check if image exists before creating
		Docker::Image.get('alpine:armhf').remove
	end
	image = Docker::Image.import(minirootfs["file"]) # create image
	image.tag('repo' => 'alpine', 'tag' => 'armhf', force: true)	
	puts "Docker image 'alpine:armhf' created (#{image.id})!"
else
	puts 'checksums do not match' # unmatched
end

File.delete(minirootfs["file"])