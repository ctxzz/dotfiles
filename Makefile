DOTPATH    := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
CANDIDATES := $(wildcard .??*) bin
EXCLUSIONS := .DS_Store .git .gitmodules .travis.yml .cursor .config .claude
DOTFILES   := $(filter-out $(EXCLUSIONS), $(CANDIDATES))

# .claude is linked item-by-item (not as a whole dir) so Claude Code's runtime
# state under ~/.claude (projects/, history/, settings.local.json, global
# skills, ...) is preserved. Skills are linked per-directory for the same reason.
CLAUDE_FILES  := CLAUDE.md settings.json ai.env
CLAUDE_SKILLS := $(wildcard .claude/skills/*/)

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
	@echo "make clean			#=> Remove the dot files and this repo"

list:
	@$(foreach val, $(DOTFILES), /bin/ls -dF $(val);)

deploy:
	@echo '==> Start to deploy dotfiles to home directory.'
	@echo ''
	@$(foreach val, $(DOTFILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)
	@echo ''
	@mkdir -p $(HOME)/.claude/skills
	@$(foreach f, $(CLAUDE_FILES), ln -sfnv $(abspath .claude/$(f)) $(HOME)/.claude/$(f);)
	@$(foreach d, $(CLAUDE_SKILLS), ln -sfnv $(abspath $(d)) $(HOME)/.claude/skills/$(notdir $(patsubst %/,%,$(d)));)

init:
	@DOTPATH=$(DOTPATH) bash $(DOTPATH)/etc/init/init.sh

test:
	@DOTPATH=$(DOTPATH) bash $(DOTPATH)/etc/test/test.sh

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
	@echo 'Remove dot files in your home directory...'
	@-$(foreach val, $(DOTFILES), rm -vrf $(HOME)/$(val);)
	@-$(foreach f, $(CLAUDE_FILES), rm -vf $(HOME)/.claude/$(f);)
	@-$(foreach d, $(CLAUDE_SKILLS), rm -vf $(HOME)/.claude/skills/$(notdir $(patsubst %/,%,$(d)));)
	-rm -rf $(DOTPATH)
