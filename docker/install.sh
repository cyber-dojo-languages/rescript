#!/bin/bash -Eeu

# /etc/rescript is where the whole ReScript toolchain lives, compiler here and
# test framework added by whichever image builds on this one. One prefix rather
# than two, because a start-point symlinks it in as its node_modules: that is
# how node finds the framework, and how the ReScript compiler finds the
# packages a kata's rescript.json names.
#
# No version is named, so a rebuild picks up the current release, and
# check_version.sh is what stops that happening silently.
npm install --prefix /etc/rescript rescript

# The compiler writes its build output beside the sources it compiles, and a
# kata runs as sandbox, so sandbox has to own this tree. The image that builds
# on this one adds packages here, so ownership is set again there.
chown -R sandbox /etc/rescript
