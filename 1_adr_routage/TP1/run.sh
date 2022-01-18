
echo "Restaurer [y/n]"
read resp
if test "$resp" = "y"; then
	echo "Restauration"
	~/iut-vms/backup/virt/nemu-restore ~/vnet/netadm.tgz 
else
	echo "Lancement simple"
	~/iut-vms/backup/virt/nemu-vnet netadm
fi
