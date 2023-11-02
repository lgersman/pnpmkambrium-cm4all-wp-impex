
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
