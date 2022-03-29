SNAPSHOT_NAME = vbguest-installed

.PHONY: vm-init
vm-init: vm-plugin-install
	vagrant up --no-provision \
	&& vagrant vbguest \
	&& vagrant reload --no-provision \
	&& vagrant snapshot save $(SNAPSHOT_NAME) \
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

.PHONY: vm-restore
vm-restore:
	vagrant snapshot restore $(SNAPSHOT_NAME) \
	&& vagrant reload --no-provision \
	&& vagrant provision \
	;

# ex) make ansible ANSIBLE_OPTS=-v
ANSIBLE_OPTS =
.PHONY: ansible
ansible:
	vagrant ssh ansible-controller -- \
	-t "cd /vagrant/provision; source /ansible/bin/activate; ansible-playbook -i hosts.yml playbook.yml $(ANSIBLE_OPTS)"

