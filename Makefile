
DOTFILES_DIR=$(shell pwd)
CONFIG_DIR=$(shell echo "${HOME}/.config")

LOCAL_BIN:=$(DOTFILES_DIR)/bin
PATH:=$(LOCAL_BIN):$(PATH)

# Config Dirs ==========================================================================================================
ZSH_CONFIG_DIR=$(shell echo "${HOME}/zsh")
ZINIT_CONFIG_DIR=$(shell echo "${HOME}/.local/share/zinit")

ALACRITTY_CONFIG_DIR=$(shell echo "${CONFIG_DIR}/alacritty")
ZELLIJ_CONFIG_DIR=$(shell echo "${CONFIG_DIR}/zellij")


# HELP =================================================================================================================
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: all

.DEFAULT_GOAL := help

help: ## Display help message
	@awk 'BEGIN {FS = ":.*##"; printf "[dot] System Setup Manager\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

clean: ## Clean all the config
	@rm -rf ${ZSH_CONFIG_DIR}
	@rm -rf ${HOME}/.zshrc
	@rm -rf ${ZINIT_CONFIG_DIR}
	@rm -rf ${ALACRITTY_CONFIG_DIR}
	@rm -rf ${ZELLIJ_CONFIG_DIR}

setup: ## Setup all the tools
	@make setup_zsh
	@make setup_alacritty
	@make setup_zellij

setup_zsh: ## Setup ZSH shell
	@ln -sfn "${DOTFILES_DIR}/zshrc" ${HOME}/.zshrc
	@ln -sfn "${DOTFILES_DIR}/zsh" ${ZSH_CONFIG_DIR}
	@eval zsh

update_zsh: ## Update ZSH and Themes
	@eval zsh
	@eval zinit self-update
	@eval zinit update
	@eval zinit

setup_alacritty: ## Copy Alacritty settings
	@ln -sfn "${DOTFILES_DIR}/alacritty" ${ALACRITTY_CONFIG_DIR}

setup_zellij: ## Copy Zellij config
	@ln -sfn "${DOTFILES_DIR}/zellij" ${ZELLIJ_CONFIG_DIR}
