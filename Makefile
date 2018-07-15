.PHONY: install
install:
	@install -m644 systemd/user/bspwm-autoremover.service ~/.config/systemd/user/
	@install -m744 autoremover.sh ~/.local/bin/
	@echo "Enable the service with systemctl --user enable --now bspwm-autoremover.service"
