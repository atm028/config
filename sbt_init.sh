#!/bin/zsh
mkdir -p src/{main,test}/{java,resources,scala}
mkdir lib project target

#create initial build.sbt file
echo 'name := "My Project"

version := "1.0"

scalaVersion := "2.10.0"

libraryDependencies ++=Seq(
    specs2 % Test
)' > build.sbt
