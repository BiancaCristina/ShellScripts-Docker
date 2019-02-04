# Script desenvolvido por Bianca Cristina
# O objetivo é realizar backups periódicos no Docker Algar
#!/bin/bash
USER1="lclaudio";
USER2="nfi";
# O "SCRIPT" é responsável por executar os comandos que realizam o backup diário
# No backup diário, não é feito backup do banco de dados 
TEMPO="4 weeks";
SCRIPT="
cd /var/teste;
sudo docker images | grep ${TEMPO} | awk '{print $3}' | xargs sudo docker rmi;
exit
"
echo "#### REMOCAO IMAGENS DOCKER ALGAR ####"

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

# Inicia o processo de remocao de imagens
echo "CONECTANDO...";
sshpass -p ${PASSWORD1} ssh -l ${USER1} ${HOST1} "${SCRIPT}";

