name := "facilitator_bot"
scalaVersion := "2.12.8"

//dependencies

val circeVersion = "0.11.1"
val reactiveAwsVersion = "1.1.0"

libraryDependencies ++= Seq(
  "io.circe" %% "circe-core",
  "io.circe" %% "circe-generic",
  "io.circe" %% "circe-parser"
).map(_ % circeVersion)

libraryDependencies ++= Seq(
  "com.amazonaws" % "aws-lambda-java-events" % "1.3.0",
  "com.amazonaws" % "aws-lambda-java-core" % "1.1.0",
  "com.pepegar" %% "hammock-core" % "0.10.0",
  "com.pepegar" %% "hammock-apache-http" % "0.10.0",
  "com.pepegar" %% "hammock-circe" % "0.10.0",
  "io.monix" %% "monix-eval" % "3.0.0",
  "com.github.j5ik2o" %% "reactive-aws-dynamodb-core" % reactiveAwsVersion,
  "com.github.j5ik2o" %% "reactive-aws-dynamodb-cats" % reactiveAwsVersion,
  "com.github.pureconfig" %% "pureconfig" % "0.12.1",
  "ch.qos.logback" % "logback-classic" % "1.2.3",
  "net.logstash.logback" % "logstash-logback-encoder" % "5.3",
  "com.fasterxml.jackson.module" %% "jackson-module-scala" % "2.9.8",
  "com.typesafe.scala-logging" %% "scala-logging" % "3.9.2",
  "com.slack.api" % "bolt-aws-lambda" % "1.0.1"
)

//compile options

wartremoverErrors ++= Warts.unsafe

addCompilerPlugin(
  "org.scalamacros" % "paradise" % "2.1.1" cross CrossVersion.full
)

scalacOptions ++= Seq(
  "-deprecation",
  "-feature",
  "-unchecked",
  "-Xlint",
  "-Ywarn-dead-code",
  "-Ywarn-numeric-widen",
  "-Ywarn-unused",
  "-Ywarn-unused-import",
  "-Ywarn-value-discard",
  "-Xfatal-warnings",
  "-language:higherKinds",
  "-Ypartial-unification"
)


// build config
assemblyJarName in assembly := "facilitator_bot.jar"
assemblyMergeStrategy in assembly := {
  case PathList("META-INF", "MANIFEST.MF") => MergeStrategy.discard
  case _ => MergeStrategy.first
}
