build:
	pandoc -st docbook abstract.markdown | xsltproc --nonet transform.xsl - > abstract.xml
	pandoc -st docbook middle.markdown | xsltproc --nonet transform.xsl - > middle.xml
	pandoc -st docbook back.markdown | xsltproc --nonet transform.xsl - > back.xml

draft: build
	xml2rfc template.xml -f draft.txt --text

clean:
	rm abstract.xml
	rm middle.xml
	rm back.xml
	rm draft.txt
