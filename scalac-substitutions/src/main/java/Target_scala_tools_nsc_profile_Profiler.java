package scala.tools.nsc.profile;

import com.oracle.svm.core.annotate.TargetClass;
import com.oracle.svm.core.annotate.Substitute;
import scala.tools.nsc.Settings;

@TargetClass(className="scala.tools.nsc.profile.Profiler$")
final class Target_scala_tools_nsc_profile_Profiler {

  @Substitute
  public Profiler apply(final Settings settings){
   return scala.tools.nsc.profile.NoOpProfiler$.MODULE$;
  }

}
