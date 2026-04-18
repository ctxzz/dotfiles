DOTPATH    := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
CANDIDATES := $(wildcard .??*) bin
EXCLUSIONS := .DS_Store .git .gitmodules .travis.yml .cursor .config .claude
DOTFILES   := $(filter-out $(EXCLUSIONS), $(CANDIDATES))

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
	-rm -rf $(DOTPATH)
