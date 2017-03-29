build:
	pandoc -st docbook abstract.markdown | xsltproc --nonet transform.xsl - > abstract.xml
	pandoc -st docbook middle.markdown | xsltproc --nonet transform.xsl - > middle.xml
	pandoc -st docbook back.markdown | xsltproc --nonet transform.xsl - > back.xml

draft: build
	xml2rfc template.xml -f draft.txt --text

exp: build
	xml2rfc template.xml -f draft-ietf-dnsop-alias-rr-type.xml --exp
clean:
	rm -f abstract.xml
	rm -f middle.xml
	rm -f back.xml
	rm -f draft.txt
