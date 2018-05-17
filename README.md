# Nexus Repository Import Scripts
## Wut?
These are bare bones bash scripts to import a Nexus 2 Maven, NuGet or npm repository (and likely other file system based repos)
into Nexus Repository 3.
### Wut does it do?
Imports artifacts into a Nexus Repository 3 Maven2, NuGet or npm hosted repo.
### Wut does it not do?
Literally anything else. You want security? Better set it up yourself.
## How do I use it?
* Maven
  * cd rootdirectorywithallyourartifacts
  * ./mavenimport.sh -u admin -p admin123 -r http://localhost:8084/repository/maven-releases/
  * Watch a bunch of verbose output from curl
  * If need be, change -u to user, -p to password, and -r (I bet you'll have to change this) to the repo you want to upload in to
* NuGet
  * cd rootdirectorywithallyournugetpackages
  * ./nugetimport.sh -k APIKEYFROMNEXUS - r http://localhost:8084/repository/nuget-hosted/
  * Watch the money roll in and the haters start askin
  * You'll need to obtain your APIKEY for Nexus Repository, and obviously set -r to the repo path you want to use
* npm
  * npm login --registry http://localhost:8084/repository/npm-internal/
  * cd rootdirectorythatcontainsallnpmmadness
  * ./npmimport.sh -r http://localhost:8084/repository/npm-internal/
  * Watch a bunch of stuff prolly fail because it has extra build steps, figure those out and then remediate if you really care
  * Set -r and --registry to the NPM hosted repo you plan to use
## Like it?
Great, buy me a beer.
