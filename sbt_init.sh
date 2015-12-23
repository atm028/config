#!/bin/zsh
mkdir -p src/{main,test}/{java,resources,scala}
mkdir lib project target

#create initial build.sbt file
echo 'name := "My Project"

version := "1.0"

scalaVersion := "2.10.0"

scalacOptions    := Seq("-unchecked", "-deprecation", "-encoding", "utf8")

scalacOptions in Test   ++= Seq("-Yrangepos")

ivyScala := ivyScala.value map { _.copy(overrideScalaVersion = true) }

libraryDependencies ++= {
    val akkaVer = "2.3.9"
    val sprayVer    = "1.3.3"
    Seq(
        "io.spray"          %% "spray-can"      % sprayVer,
        "io.spray"          %% "spray-routing"  % sprayVer,
        "io.spray"          %% "spray-testkit"  % sprayVer % "test",
        "io.spray"          %% "spray-json"     % "1.3.2",
        "com.typesafe.akka" %% "akka-actor"     % akkaVer,
        "com.typesafe.akka" %% "akka-testkit"   % akkaVer % "test",
        "org.specs2"        %% "specs2-core"    % "2.3.11" % "test"
    )
}

Revolver.settings' > build.sbt

#create plugins.sbt
echo '
addSbtPlugin("io.spray" % "sbt-revolver" % "0.7.2")

addSbtPlugin("com.eed3si9n" % "sbt-assembly" % "0.13.0")
' > project/plugins.sbt
