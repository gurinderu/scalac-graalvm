#!/bin/sh

[ -z "$GRAALVM_HOME" ] && echo "GRAALVM_HOME is currently not set. This script will not work." && exit 1
[ ! -f "$GRAALVM_HOME/bin/native-image" ] && echo "Can't find native-image in $GRAALVM_HOME. Check that the directory is valid." && exit 1
[ -z "$SCALA_HOME" ] && echo "SCALA_HOME is currently not set. This script will not work." && exit 1
SCALA_LIB="$SCALA_HOME/lib"
if [ -d "$SCALA_HOME/libexec" ]; then
   SCALA_LIB="$SCALA_HOME/libexec/lib"
fi
[ ! -d "$SCALA_LIB" ] && echo "Can't find jars in $SCALA_LIB. Check that the Scala instalation is correct." && exit 1
for filename in $SCALA_LIB/*.jar; do
    SCALA_LIB_CLASSPATH=$filename:$SCALA_LIB_CLASSPATH
done

$GRAALVM_HOME/bin/native-image --no-fallback \
	--verbose \
	--install-exit-handlers \
	--trace-object-instantiation=sun.awt.dnd.SunDropTargetContextPeer \
	--trace-object-instantiation=java.awt.color.ICC_ColorSpace \
	--report-unsupported-elements-at-runtime \
	--initialize-at-build-time \
	--initialize-at-run-time=scala.tools.nsc.profile.RealProfiler$,scala.tools.nsc.profile.ExtendedThreadMxBean,scala.tools.nsc.classpath.FileBasedCache$,sun.awt.dnd,sun.java2d.SurfaceData \
	-H:+ReportExceptionStackTraces \
	-H:Name=scalac \
	-cp $SCALA_LIB_CLASSPATH:$PWD/svm-subs_2.13-20.2.0.jar scala.tools.nsc.Main $@
