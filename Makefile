include make-common.mk

NEO4J_BASE_IMAGE?="openjdk:11-jdk-slim"

# Use make test TESTS='<pattern>' to run specific tests
# e.g. `make test TESTS='TestCausalCluster'` or `make test TESTS='*Cluster*'`
# the value of variable is passed to the maven test property. For more info see https://maven.apache.org/surefire/maven-surefire-plugin/examples/single-test.html
# by default this is empty which means all tests will be run
TESTS?=""

all: tag
.PHONY: all

## tagging the images ##
tag: tag-community tag-enterprise
.PHONY: tag

tag-community: build-community
> docker tag $$(cat tmp/.image-id-community) neo4j:$(NEO4JVERSION)
> docker tag $$(cat tmp/.image-id-neo4j-admin-community) neo4j/neo4j-admin:$(NEO4JVERSION)

tag-enterprise: build-enterprise
> docker tag $$(cat tmp/.image-id-enterprise) neo4j:$(NEO4JVERSION)-enterprise
> docker tag $$(cat tmp/.image-id-neo4j-admin-enterprise) neo4j/neo4j-admin:$(NEO4JVERSION)-enterprise


# create release images and loadable images
package: package-community package-enterprise
.PHONY: package

package-community:  tag-community out/community/.sentinel out/neo4j-admin-community/.sentinel
> mkdir -p out
> docker save neo4j:$(NEO4JVERSION) > out/neo4j-community-$(NEO4JVERSION)-docker-loadable.tar
> docker save neo4j/neo4j-admin:$(NEO4JVERSION) > out/neo4j-admin-community-$(NEO4JVERSION)-docker-loadable.tar

package-enterprise:  tag-enterprise out/enterprise/.sentinel out/neo4j-admin-enterprise/.sentinel
> mkdir -p out
> docker save neo4j:$(NEO4JVERSION)-enterprise > out/neo4j-enterprise-$(NEO4JVERSION)-docker-loadable.tar
> docker save neo4j/neo4j-admin:$(NEO4JVERSION)-enterprise > out/neo4j-admin-enterprise-$(NEO4JVERSION)-docker-loadable.tar
