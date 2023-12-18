
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

# HELP<<EOF
# works just like `wp-env-phpunit` target but interactive
#
# example: `make wp-env-phpunit-interactive`
#
#  lets you select and run phpunit testcases
#
# example: `make wp-env-phpunit-interactive ARGS='--verbose --debug'`
#
# lets you select and run phpunit testcases. testcases will be executed whit ARGS supplied to phpunit command
#
# EOF
.PHONY: wp-env-phpunit-interactive
wp-env-phpunit-interactive: ARGS ?=
wp-env-phpunit-interactive: wp-env-is-started
> # @TODO: multiple filters doenst work (yet)
> find packages/wp-plugin/cm4all-wp-impex/tests/phpunit -name "*Test.php" -exec basename {} .php \; | fzf --no-mouse --multi --bind 'enter:execute(make wp-env-phpunit ARGS="--filter={+} $(ARGS)"; kill $$PPID)' ||:

# DOCKER_IMPEXCLI_PHPUNIT_IMAGE := cm4all-wp-impex/impex-cli-phpunit
# HELP<<EOF
# starts the wp-cli tests
#
# example: `make impex-cli-tests`
#
#  run impex-cli phpunit testcases
#
# example: `make impex-cli-tests ARGS='--verbose --debug'`
#
# lets you select and run phpunit testcases. testcases will be executed whit ARGS supplied to phpunit command
#
# EOF
# .PHONY: impex-cli-tests
# impex-cli-tests: ARGS ?=
# impex-cli-tests: wp-env-is-started
# > # 2 options : either reuse the wp-env contaer (how is its name ?) or create a new one locally exclusively for impex-cli tests
# > $(MAKE) wp-env-sh CONTAINER='tests-wordpress' ARGS='XDEBUG_CONFIG="client_host=host.docker.internal" /var/www/html/wp-content/plugins/cm4all-wp-impex/vendor/bin/phpunit -c /var/www/html/wp-content/plugins/cm4all-wp-impex/tests/phpunit/phpunit.xml $(ARGS) --testsuite=ImpexCliTestSuite'
