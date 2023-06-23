# fence_kube
Experimental fence agent for kubernetes' nodes.
Requires kubectl and a kubeconfig file with (un) cordon and drain permissions
on all nodes, which may be a security risk if done incorrectly.

The point of this device is to report to kubernetes' apiserver when a node is
being fenced out, so the pods can be rescheduled on other nodes. After
cordoning and draining, this device will report failure. This device should
always fail.

To set this up in a pacemaker cluster, add it as a stonith device then
configure it as level 1 on all targets. You must also add a real stonith device
to your cluster at level 2 or higher or fencing will always fail.

```bash
$ pcs stonith create my-kube-fence fence_kube
$ pcs stonith level add 1 my-node-1 my-kube-fence
$ pcs stonith level add 1 my-node-2 my-kube-fence
$ pcs stonith level add 2 my-node-1 my-real-fence
$ pcs stonith level add 2 my-node-2 my-real-fence
```

This device does not provide un-fencing ('on' action). To uncordon a kubernetes
node, you could modify the start action of your kubelet service to uncordon the
node after a successful startup.

for systemd:
```ini
...
[Service]
ExecStartPost=/bin/sh -c "/usr/bin/kubectl --kubeconfig=/etc/kubernetes/admin.conf uncordon ${NODE_NAME}"
...
```
