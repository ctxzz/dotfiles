DOTPATH    := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
CANDIDATES := $(wildcard .??*) bin
EXCLUSIONS := .DS_Store .git .gitmodules .travis.yml .cursor .config
DOTFILES   := $(filter-out $(EXCLUSIONS), $(CANDIDATES))

# claude/ (dot-less so Claude Code ignores it while editing this repo) is
# linked item-by-item into ~/.claude so Claude Code's runtime state there
# (projects/, history/, settings.local.json, global skills, ...) is preserved.
# Skills are linked per-directory for the same reason.
CLAUDE_FILES  := CLAUDE.md settings.json ai.env
CLAUDE_SKILLS := $(wildcard claude/skills/*/)

# link SRC DST: replace DST with a symlink to SRC. A real file/dir already at DST
# is moved aside to DST.bak.<timestamp> instead of being overwritten or, for a
# directory, having the link created inside it.
LINK = link() { \
	if [ -e "$$2" ] && [ ! -L "$$2" ]; then \
		mv -v "$$2" "$$2.bak.$$(date +%Y%m%d%H%M%S)"; \
	fi; \
	ln -sfnv "$$1" "$$2"; \
}

# unlink DST: remove DST only if it is a symlink pointing into this repo, so
# clean never touches real files or links owned by something else.
UNLINK = unlink_own() { \
	if [ -L "$$1" ]; then \
		case "$$(readlink "$$1")" in \
			$(DOTPATH)/*) rm -v "$$1" ;; \
			*) echo "skip (not linked to $(DOTPATH)): $$1" ;; \
		esac; \
	fi; \
}

all: install

help:
	@echo "make list			#=> Show dot files in this repo"
	@echo "make deploy			#=> Create symlink to home directory"
	@echo "make init			#=> Setup environment settings"
	@echo "make test			#=> Test dotfils and init scripts"
	@echo "make test-container              #=> Test in Podman container (default: OS=ubuntu)"
	@echo "make test-container OS=ubuntu   #=> ubuntu / fedora / arch / macos / windows"
	@echo "make test-container-full OS=... #=> Same + make init (package install)"
	@echo "make update			#=> Fetch changes for this repo"
	@echo "make install			#=> Run make update, deploy, init"
	@echo "make lint-fix			#=> Apply shellcheck auto-fixes to scripts (modifies files)"
	@echo "make clean			#=> Remove symlinks created by deploy (only those pointing into this repo)"
	@echo "make uninstall			#=> make clean, then delete this repo"

list:
	@$(foreach val, $(DOTFILES), /bin/ls -dF $(val);)

deploy:
	@echo '==> Start to deploy dotfiles to home directory.'
	@echo ''
	@$(LINK); $(foreach val, $(DOTFILES), link $(abspath $(val)) $(HOME)/$(val);)
	@echo ''
	@mkdir -p $(HOME)/.claude/skills
	@$(LINK); $(foreach f, $(CLAUDE_FILES), link $(abspath claude/$(f)) $(HOME)/.claude/$(f);)
	@$(foreach d, $(CLAUDE_SKILLS), \
		name=$(notdir $(patsubst %/,%,$(d))); \
		if [ -e "$(HOME)/.claude/skills/$$name" ] && [ ! -L "$(HOME)/.claude/skills/$$name" ]; then \
			echo "skip (coexists with global skill): $$name"; \
		else \
			ln -sfnv $(abspath $(d)) $(HOME)/.claude/skills/$$name; \
		fi;)
	@echo ''
	@# nvim config lives under ~/.config, which is excluded from DOTFILES
	@# (manual management). Link it explicitly so ~/.config/nvim -> repo nvim/.
	@mkdir -p $(HOME)/.config
	@$(LINK); link $(abspath nvim) $(HOME)/.config/nvim

init:
	@DOTPATH=$(DOTPATH) bash $(DOTPATH)/etc/init/init.sh

test:
	@DOTPATH=$(DOTPATH) bash $(DOTPATH)/etc/test/test.sh

lint-fix:
	@DOTPATH=$(DOTPATH) bash $(DOTPATH)/etc/test/shellcheck_fix.sh

test-container:
	@bash $(DOTPATH)/etc/test/run_container.sh $(OS)

test-container-full:
	@bash $(DOTPATH)/etc/test/run_container.sh $(OS) --init

update:
	git pull origin master
	git submodule init
	git submodule update
	git submodule foreach git pull origin master

install: update deploy init
	@exec $$SHELL

clean:
	@echo 'Remove symlinks created by deploy from your home directory...'
	@$(UNLINK); $(foreach val, $(DOTFILES), unlink_own $(HOME)/$(val);)
	@$(UNLINK); $(foreach f, $(CLAUDE_FILES), unlink_own $(HOME)/.claude/$(f);)
	@$(UNLINK); $(foreach d, $(CLAUDE_SKILLS), unlink_own $(HOME)/.claude/skills/$(notdir $(patsubst %/,%,$(d)));)
	@$(UNLINK); unlink_own $(HOME)/.config/nvim

uninstall: clean
	rm -rf $(DOTPATH)
