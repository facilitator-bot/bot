name := "facilitator_bot"
scalaVersion := "2.13.4"

//dependencies

val circeVersion = "0.13.0"
val reactiveAwsVersion = "1.2.6"

libraryDependencies ++= Seq(
  "io.circe" %% "circe-core",
  "io.circe" %% "circe-generic",
  "io.circe" %% "circe-parser"
).map(_ % circeVersion)

libraryDependencies ++= Seq(
  "ch.qos.logback" % "logback-classic" % "1.2.3",
  "com.typesafe.scala-logging" %% "scala-logging" % "3.9.2",
  "io.monix" %% "monix-eval" % "3.3.0",
  "com.github.j5ik2o" %% "reactive-aws-dynamodb-core" % reactiveAwsVersion,
  "com.github.j5ik2o" %% "reactive-aws-dynamodb-cats" % reactiveAwsVersion,
  "net.logstash.logback" % "logstash-logback-encoder" % "6.6",
  "com.github.pureconfig" %% "pureconfig" % "0.14.0",
  "com.fasterxml.jackson.module" %% "jackson-module-scala" % "2.12.1",
  "com.slack.api" % "bolt-aws-lambda" % "1.6.1"
)

unusedCompileDependenciesFilter -= moduleFilter("ch.qos.logback", "logback-classic")
unusedCompileDependenciesFilter -= moduleFilter("com.fasterxml.jackson.module", "jackson-module-scala")
unusedCompileDependenciesFilter -= moduleFilter("com.github.pureconfig", "pureconfig")
unusedCompileDependenciesFilter -= moduleFilter("net.logstash.logback" , "logstash-logback-encoder")

//compile options
wartremoverErrors ++= Warts.unsafe
scalacOptions ++= Seq(
  "-deprecation",
  "-feature",
  "-unchecked",
  "-Xlint:_,-byname-implicit", //enable handy linter warnings without byname implicit https://github.com/scala/bug/issues/12072
  "-Ywarn-dead-code",
  "-Ywarn-numeric-widen",
  "-Ywarn-unused",
  "-Ywarn-unused:imports",
  "-Ywarn-value-discard",
  "-Xfatal-warnings",
  "-language:higherKinds",
  "-Ymacro-annotations"
)


// build config
assemblyJarName in assembly := "facilitator_bot.jar"
assemblyMergeStrategy in assembly := {
  case PathList("META-INF", "MANIFEST.MF") => MergeStrategy.discard
  case _ => MergeStrategy.first
}
