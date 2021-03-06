.PHONY: install
install:
	@install -m644 systemd/user/bspwm-autoremover.service ~/.config/systemd/user/
	@install -m744 autoremover.sh ~/.local/bin/
	@install -m744 autonamer.sh ~/.local/bin/
	@install -m744 program_to_desktop_name.sh ~/.local/bin/
	@install -m744 change_bspwm_desktop_name ~/.local/bin/
	@echo "Enable the service with systemctl --user enable --now bspwm-autoremover.service"
	@echo "Add 'bspc config external_rules_command ~/.local/bin/autonamer.sh' to bspwmrc"
