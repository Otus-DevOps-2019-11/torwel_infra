# torwel_infra
torwel Infra repository




#	-----===[   packer-base   ]===-----

# Создан packer-шаблон ubuntu16.json. Используя его, получим ВМ с установленным Ruby и MongoDB.
# Команда для создания ВМ:

packer build -var-file variables.json ubuntu1604.json

# Создан packer-шаблон immutable.json. Используя его, получим ВМ с установленным окружением
# и запущенным приложением Reddit.
# Команда для создания ВМ:

packer build -var-file variables.json immutable.json

# Файл variables.json содержит параметры для шаблонов.

# Также создан скрипт create-reddit-vm.sh, при выполнении которого в GCP создается инстанс ВМ,
# с полностью готовый к работе.



#	-----===[   cloud-testapp   ]===-----


testapp_IP = 34.65.112.216
testapp_port = 9292


# Команда для создания экземпляра ВМ с выполнением скрипта натройки
# окружения и установки сервера Puma

gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --metadata-from-file startup-script=/home/orwel/otus-devops/torwel_infra/startup_script.sh



# Команда для создания правила файерволла с помощью gcloud

gcloud compute firewall-rules create default-puma-server --allow=TCP:9292




#	-----===[   cloud-bastion   ]===-----


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

