.PHONY: index.txt all

all:
	unison -silent ~/g/inclusive-yp ssh://sakura//home/plonk/domains/inclusive-yp

index.txt:
	bundle exec ruby generate.rb > index.txt.new && mv index.txt.new index.txt
