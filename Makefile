.PHONY: vm-init
vm-init: vm-plugin-install
	vagrant up --no-provision \
	&& vagrant vbguest \
	&& vagrant reload --no-provision \
	&& vagrant provision \
	;

.PHONY: vm-destroy
vm-destroy: vm-plugin-install
	vagrant destroy -f \
	;

.PHONY: vm-plugin-install
vm-plugin-install:
	vagrant plugin expunge --local --force; vagrant plugin install --local;

.PHONY: vm-rebuild
vm-rebuild: vm-destroy vm-init
