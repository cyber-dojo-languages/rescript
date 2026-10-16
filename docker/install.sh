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

# Records the ReScript this image holds, in the shape every image shares. The
# installed compiler is asked, so the version is one the image can run rather
# than one written down when someone last edited this file.
# rescript --version prints "rescript 12.3.1".
readonly LANGUAGE_VERSION=$(/etc/rescript/node_modules/.bin/rescript --version | cut -d' ' -f2)

if [ -z "${LANGUAGE_VERSION}" ]; then
  echo 'Could not read a version from rescript --version' >&2
  exit 1
fi

cat > /versions.json <<EOF
{
  "language": {
    "name": "ReScript",
    "version": "${LANGUAGE_VERSION}"
  },
  "test_frameworks": []
}
EOF
