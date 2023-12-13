
include node_modules/@pnpmkambrium/core/make/make.mk

# add hook calling wp-env destroy if wp-env-home exists
IMPEX_BEFORE_CLEAN_HOOKS := && ([[ ! -d "$(WP_ENV_HOME)" ]] || echo 'y' | $(MAKE) -s wp-env-destroy)
# destroy wp-env if running before clean actions
clean: BEFORE_CLEAN_HOOKS += $(IMPEX_BEFORE_CLEAN_HOOKS)

#
# prevent deletion of additional project specific files
#
IMPEX_GIT_CLEAN_ARGS := -e '!/.wp-env.json' \
  -e '!/.wp-env.override.json' \
  -e '!/.wp-env-afterStart.sh' \
  -e '!/TODO.md'

clean: GIT_CLEAN_ARGS += $(IMPEX_GIT_CLEAN_ARGS) -e '!.vscode/launch.json' -e '!/wp-env-backup'
distclean: GIT_CLEAN_ARGS += $(IMPEX_GIT_CLEAN_ARGS)

# HELP<<EOF
# runs phpunit
#
# supported make variables:
#   - ARGS (default=``) the wp-env command arguments
#
# example: `make wp-env-phpunit`
#
#   run all tests
#
# example: `make wp-env-phpunit ARGS='--verbose --filter=TestImpexSingleton'`
#
#   run only testcase TestImpexSingleton and output verbose information
#
# example: `make wp-env-phpunit ARGS='--verbose --filter="TestImpexSingleton|TestImpexPart"'`
#
#   run multiple testcases by name (TestImpexSingleton and TestImpexPart) and output verbose information
#
# example: `make wp-env-phpunit ARGS='--debug --filter=.+Singleton'`
#
#   run all testcases with name ending with Singleton and output phpunit debug information
#
# example: `make wp-env-phpunit ARGS='--verbose --filter=TestImpexSingleton::testSingletonInitialized'`
#
#   run only testcase function TestImpexSingleton::testSingletonInitialized and output verbose information
#
# see https://docs.phpunit.de/en/8.5/textui.html#command-line-options for more phpunit commandline options to apply
# EOF
.PHONY: wp-env-phpunit
wp-env-phpunit: ARGS ?=
wp-env-phpunit: wp-env-is-started
> $(MAKE) wp-env-sh CONTAINER='tests-wordpress' ARGS='XDEBUG_CONFIG="client_host=host.docker.internal" /var/www/html/wp-content/plugins/cm4all-wp-impex/vendor/bin/phpunit -c /var/www/html/wp-content/plugins/cm4all-wp-impex/tests/phpunit/phpunit.xml $(ARGS)'

# .PHONY: test-phpunit-single-test
# #HELP: select testcase to run interactively with fzf
# test-phpunit-single-test: node_modules $(WP_ENV_HOME) plugins/cm4all-wp-impex/vendor/autoload.php
# > find plugins/*/tests/phpunit -name "test-*.php" | fzf --bind 'enter:execute(make test-phpunit ARGS="--verbose --filter={}"; kill $$PPID)' ||:
