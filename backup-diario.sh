# Script desenvolvido por Bianca Cristina
# O objetivo é realizar backups periódicos no Docker Algar
#!/bin/bash
USER1="lclaudio";
USER2="nfi";
# O "SCRIPT" é responsável por executar os comandos que realizam o backup diário
# No backup diário, não é feito backup do banco de dados 

SCRIPT="
cd /var/teste; 
sudo rm -rf *; 

sudo docker commit -p 113d96881885 backup-dcim-`date +%d-%m-%Y`;
sudo docker commit -p cba6abe91c50 backup-portalh-`date +%d-%m-%Y`;
sudo docker commit -p 696369ee1543 backup-wiki-`date +%d-%m-%Y`; 

sudo docker save -o backup-dcim-`date +%d-%m-%Y`.tar backup-dcim-`date +%d-%m-%Y`;
sudo docker save -o backup-portalh-`date +%d-%m-%Y`.tar backup-portalh-`date +%d-%m-%Y`;
sudo docker save -o backup-wiki-`date +%d-%m-%Y`.tar backup-wiki-`date +%d-%m-%Y`;

sudo chmod 777 *;
ls -l; 
exit;
"
echo "#### BACKUP DOCKER ####"

# Pede o HOST do tipo user@host
echo "Digite o host de lclaudio (10.X.X.X): "
read HOST1;
echo "Digite o host de nfi (10.X.X.X): "
read HOST2;

# Pede senhas das VMs
echo "Senha para lclaudio: ";
read PASSWORD1;
echo "Confirme a senha para lclaudio: "
read PASSWORD_1;

if [ $PASSWORD1 = $PASSWORD_1 ]; then
	echo "Senha para lclaudio confere!"

else
	while [ $PASSWORD1 != $PASSWORD_1 ]
		do
			echo "Senhas diferentes. Por favor, digite a senha para lclaudio: "
			read PASSWORD1;
			echo "Confirme a senha para lclaudio: "
			read PASSWORD_1;
		done
	
	echo "Senha para lclaudio confere!"
fi

echo "Senha para nfi: ";
read PASSWORD2;
echo "Confirme a senha para nfi: "
read PASSWORD_2;

if [ $PASSWORD2 = $PASSWORD_2 ]; then
	echo "Senha para nfi confere!"

else
	while [ $PASSWORD2 != $PASSWORD_2 ]
		do
			echo "Senhas diferentes. Por favor, digite a senha para nfi: "
			read PASSWORD2;
			echo "Confirme a senha para nfi: "
			read PASSWORD_2;
		done
	
	echo "Senha para nfi confere!"
fi

# Inicia o processo de backup
echo "CONECTANDO...";
sshpass -p ${PASSWORD1} ssh -l ${USER1} ${HOST1} "${SCRIPT}";

# Copia os arquivos pra minha maquina
echo "CRIACAO DAS IMAGENS E .TAR CONCLUIDO!";
echo "INICIANDO COPIA DOS ARQUIVOS PARA MAQUINA LOCAL";
cd ~/Backup/now;

lftp -u ${USER1},${PASSWORD1} sftp://${HOST1} << --EOF--
cd /var/teste
get backup-dcim-`date +%d-%m-%Y`.tar
get backup-portalh-`date +%d-%m-%Y`.tar
get backup-wiki-`date +%d-%m-%Y`.tar
quit
--EOF--
ls -l ~/Backup/now;

# Copia os arquivos para a nfi
echo "COPIANDO OS ARQUIVOS PARA NFI...";
lftp -u ${USER2},${PASSWORD2} sftp://${HOST2} << --EOF--
cd /home/nfi/Bianca/Backup/
put backup-dcim-`date +%d-%m-%Y`.tar
put backup-portalh-`date +%d-%m-%Y`.tar
put backup-wiki-`date +%d-%m-%Y`.tar
ls -l /home/nfi/Bianca/Backup/; 
quit
--EOF--
