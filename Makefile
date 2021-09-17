.PHONY: run index.txt

run:
	bundle exec rackup

index.txt:
	bundle exec ruby generate.rb > index.txt.new && mv index.txt.new index.txt
