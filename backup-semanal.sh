#!/bin/bash
USER1="lclaudio";
USER2="nfi";

# O "SCRIPT" é responsável por executar os comandos que realizam o backup semanal
SCRIPT="
cd /var/teste; 

sudo docker commit -p 113d96881885 backup-dcim-`date +%d-%m-%Y`;
sudo docker commit -p 17cd7f923de2 backup-mysql-`date +%d-%m-%Y`;
sudo docker commit -p cba6abe91c50 backup-portalh-`date +%d-%m-%Y`;
sudo docker commit -p 696369ee1543 backup-wiki-`date +%d-%m-%Y`; 

sudo docker save -o backup-dcim-`date +%d-%m-%Y`.tar backup-dcim-`date +%d-%m-%Y`;
sudo docker save -o backup-mysql-`date +%d-%m-%Y`.tar backup-mysql-`date +%d-%m-%Y`;
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
echo "Senha para nfi: ";
read PASSWORD2;

# Inicia o processo de backup
echo "CONECTANDO A lclaudio...";
sshpass -p ${PASSWORD1} ssh -l ${USER1} ${HOST1} "${SCRIPT}";
echo "CRIACAO DAS IMAGENS E .TAR CONCLUIDO!";

echo "INICIANDO COPIA DOS ARQUIVOS PARA MAQUINA LOCAL";
cd ~/Backup/now;

lftp -u ${USER1},${PASSWORD1} sftp://${HOST1} << --EOF--
cd /var/teste
get backup-dcim-`date +%d-%m-%Y`.tar
get backup-mysql-`date +%d-%m-%Y`.tar
get backup-portalh-`date +%d-%m-%Y`.tar
get backup-wiki-`date +%d-%m-%Y`.tar
quit
--EOF--

ls -l ~/Backup/now;

