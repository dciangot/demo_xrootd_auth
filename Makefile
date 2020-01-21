DOCBIN?=mkdocs

all: publish-doc

publish-doc:
	cp README.md docs/README.md
	$(DOCBIN) gh-deploy