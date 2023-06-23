.PHONY: install,uninstall

install: agent/fence_kube
	cp agent/fence_kube /usr/sbin/fence_kube
	chmod +x /usr/sbin/fence_kube

uninstall:
	rm /usr/sbin/fence_kube
