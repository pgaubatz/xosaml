#/bin/sh

java -classpath lib/resolver.jar:lib/serializer.jar:lib/xercesImpl.jar:lib/xjparse.jar com.nwalsh.parsers.xjparse $*
