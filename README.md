# torwel_infra
torwel Infra repository


bastion_IP = 104.155.81.87 
someinternalhost_IP = 10.132.0.4


# Самостоятельное задание
# Подключение к someinternalhost в одну команду
# ssh -At -i ~/.ssh/appuser appuser@104.155.81.87 ssh 10.132.0.4

# или

# ssh -At appuser@104.155.81.87 ssh 10.132.0.4



# Дополнительное задание
# Необходимо дополнить(создать) файл строками:

# cat ~/.ssh/config
# Host someinternalhost
#    HostName 10.132.0.4
#    User appuser
#    ProxyCommand ssh -W %h:%p -i ~/.ssh/appuser appuser@104.155.81.87

# Теперь подключиться на ВМ удаленной локальной сети
# через bastion можно c помощью команды вида
# ssh someinternalhost


