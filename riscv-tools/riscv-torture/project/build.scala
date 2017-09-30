import sbt._
import Keys._

object BuildSettings
{
  val buildOrganization = "edu.berkeley.cs"
  val buildVersion = "1.1"
  val buildScalaVersion = "2.11.6"

  val buildSettings = Defaults.defaultSettings ++ Seq (
    organization := buildOrganization,
    version      := buildVersion,
    scalaVersion := buildScalaVersion
  )
}

object TortureBuild extends Build
{
  import BuildSettings._

  lazy val torture = Project(id = "torture", base = file("."), settings = buildSettings) aggregate(generator, testrun, overnight, fileop)
  lazy val generator = Project(id = "generator", base = file("generator"), settings = buildSettings ++ Seq(libraryDependencies ++= Seq(scopt)))
  lazy val testrun = Project(id = "testrun", base = file("testrun"), settings = buildSettings ++ Seq(libraryDependencies ++= Seq(scopt))) dependsOn(generator)
  lazy val overnight = Project(id = "overnight", base = file("overnight"), settings = buildSettings ++ Seq(libraryDependencies ++= Seq(scopt, iocore, iofile))) dependsOn(testrun, fileop)
  lazy val fileop = Project(id = "fileop", base = file("fileop"), settings = buildSettings ++ Seq(libraryDependencies ++= Seq(scopt, iocore, iofile)))

  val scopt  = "com.github.scopt" %% "scopt" % "3.3.0"
  val iocore = "com.github.scala-incubator.io" %% "scala-io-core" % "0.4.3"
  val iofile = "com.github.scala-incubator.io" %% "scala-io-file" % "0.4.3"
}
