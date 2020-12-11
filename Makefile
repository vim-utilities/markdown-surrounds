#!/usr/bin/make -f


# Install/Uninstall make script for `markdown-surrounds` Vim plugin
# Copyright (C) 2020 S0AndS0
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, version 3 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.


#
#    Make variables to satisfy conventions
#
NAME = markdown-surrounds
VERSION = 0.0.1
PKG_NAME = $(NAME)-$(VERSION)


#
#    Make variables that readers &/or maintainers may wish to modify
#
PLUGIN_DIRECTORY = $(HOME)/.vim/plugin
DOCUMENTATION_DIRECTORY = $(HOME)/.vim/doc


#
#    Make variables set upon run-time
#
## Obtain directory path that this Makefile lives in
##  Note ':=' is to avoid late binding that '=' entails
ROOT_DIRECTORY_PATH := $(realpath $(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
ROOT_DIRECTORY_NAME := $(notdir $(patsubst %/,%,$(ROOT_DIRECTORY_PATH)))


## Detect Operating System
ifeq '$(findstring :,$(PATH))' ';'
	__OS__ := Windows
else
	__OS__ := $(shell uname 2>/dev/null || echo 'Unknown')
	__OS__ := $(patsubst CYGWIN%,Cygwin,$(__OS__))
	__OS__ := $(patsubst MSYS%,MSYS,$(__OS__))
	__OS__ := $(patsubst MINGW%,MSYS,$(__OS__))
endif


#
#    Override variables via optional configuration file
#
CONFIG := $(ROOT_DIRECTORY_PATH)/.make-config
ifneq ("$(wildcard $(CONFIG))", "")
	include $(CONFIG)
endif


#
#    Make options/commands
#
.PHONY: clean install uninstall upgrade git-pull list plugin-link plugin-unlink documentation-link documentation-unlink documentation-update
.SILENT: config clean debug list plugin-link plugin-unlink documentation-link documentation-unlink documentation-update
.ONESHELL: install

clean: SHELL := /bin/bash
clean: ## Removes configuration file
	[[ -f "$(CONFIG)" ]] && {
		rm -v "$(CONFIG)"
	}

config: SHELL := /bin/bash
config: ## Writes configuration file
	tee "$(CONFIG)" 1>/dev/null <<EOF
	PLUGIN_DIRECTORY = $(PLUGIN_DIRECTORY)
	DOCUMENTATION_DIRECTORY = $(DOCUMENTATION_DIRECTORY)
	__OS__ = $(__OS__)
	EOF

install: ## Runs targets -> plugin-link documentation-link documentation-update
install: | plugin-link documentation-link documentation-update

uninstall: ## Runs targets -> plugin-unlink documentation-unlink documentation-update
uninstall: | plugin-unlink documentation-unlink documentation-update

upgrade: ## Runs targets -> uninstall git-pull install
upgrade: | uninstall git-pull install

git-pull: SHELL := /bin/bash
git-pull: ## Pulls updates from default upstream Git remote
	cd "$(ROOT_DIRECTORY_PATH)"
	git pull
	[[ -f "$(ROOT_DIRECTORY_PATH)/.gitmodules" ]] && {
		git submodule update --init --merge --recursive
	}

plugin-link: SHELL := /bin/bash
plugin-link: ## Symbolically links Vim plugin
	if [[ -L "$(PLUGIN_DIRECTORY)/$(ROOT_DIRECTORY_NAME)" ]]; then
		printf '  Link found for plugin -> %s\n' "$(ROOT_DIRECTORY_NAME)"
	else
		ln -sv "$(ROOT_DIRECTORY_PATH)" "$(PLUGIN_DIRECTORY)/$(ROOT_DIRECTORY_NAME)"
	fi

plugin-unlink: SHELL := /bin/bash
plugin-unlink: ## Removes symbolic links for Vim plugin
	if [[ -L "$(PLUGIN_DIRECTORY)/$(ROOT_DIRECTORY_NAME)" ]]; then
		rm -v "$(PLUGIN_DIRECTORY)/$(ROOT_DIRECTORY_NAME)"
	else
		printf '  No link found for plugin -> %s\n' "$(ROOT_DIRECTORY_NAME)"
	fi

documentation-link: SHELL := /bin/bash
documentation-link: ## Symbolically links Vim documentation
	if [[ -d "$(ROOT_DIRECTORY_PATH)/doc" ]]; then
		for _path in "$(ROOT_DIRECTORY_PATH)/doc/"*.txt; do
			if [[ -f "$${_path}" ]] && ! [[ -L "$(DOCUMENTATION_DIRECTORY)/$${_path##*/}" ]]; then
				ln -sv "$${_path}" "$(DOCUMENTATION_DIRECTORY)/$${_path##*/}"
			else
				printf '  Link found for documentation -> %s\n' "$${_path##*/}"
			fi
		done
	fi

documentation-unlink: SHELL := /bin/bash
documentation-unlink: ## Removes symbolic links for Vim documentation
	if [[ -d "$(ROOT_DIRECTORY_PATH)/doc" ]]; then
		for _path in "$(ROOT_DIRECTORY_PATH)/doc/"*.txt; do
			if [[ -L "$(DOCUMENTATION_DIRECTORY)/$${_path##*/}" ]]; then
				rm -v "$(DOCUMENTATION_DIRECTORY)/$${_path##*/}"
			else
				printf '  No link found for documentation -> %s\n' "$${_path##*/}"
			fi
		done
	fi

documentation-update: SHELL := /bin/bash
documentation-update: ## Updates Vim documentation tag file
	vim -c ":helptags $(DOCUMENTATION_DIRECTORY)" -c ':q'

list: SHELL := /bin/bash
list: ## Lists available make commands
	gawk 'BEGIN {
		delete matched_lines
	}
	{
		if ($$0 ~ "^[a-z0-9A-Z-]{1,32}: [#]{1,2}[[:print:]]*$$") {
			matched_lines[length(matched_lines)] = $$0
		}
	}
	END {
		print "## Make Commands for $(NAME) ##\n"
		for (k in matched_lines) {
			split(matched_lines[k], line_components, ":")
			gsub(" ## ", "    ", line_components[2])
			print line_components[1]
			print line_components[2]
			if ((k + 1) != length(matched_lines)) {
				print
			}
		}
	}' "$(ROOT_DIRECTORY_PATH)/Makefile"

