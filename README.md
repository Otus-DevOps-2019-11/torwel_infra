# torwel_infra
torwel Infra repository



## [   HW 11: ansible-2   ]


Используем плейбуки, хендлеры и шаблоны для конфигурации окружения и деплоя тестового приложения. В работе применяем разные подходы.

__1. Один плейбук, один сценарий.__
В одном файле содержатся задачи для настройки сервера приложения, сервера БД и развертывания самого приложения. При выполнении плейбука необходимо использовать опции  `--limit` и `--tags` для запуска необходимых задач на группах определенных хостов.
Пример проверки плейбука:
```
$ ansible-playbook reddit_app_one_play.yml --check --limit app --tags deploy-tag
```
Пример запуска плейбука:
```
$ ansible-playbook reddit_app_one_play.yml --limit app --tags deploy-tag
```

__2. Один плейбук, но много сценариев.__
Задачи для групп хостов разделены на разные сценарии со своими тегами. Но сценарии содержатся в одном файле плейбуке. Теперь для запуска определенных задач достаточно указать только тег. Нет необходимости помнить к каким хостам их нужно применить.
Пример проверки и применения плейбука:
```
$ ansible-playbook reddit_app_multiple_plays.yml --tags deploy-tag --check
$ ansible-playbook reddit_app_multiple_plays.yml --tags deploy-tag
```

__3. Много плейбуков.__
Каждый сценарий содержится в отдельном файле. Для запуска плейбука достаточно указать только его имя. Теперь появилась возможность создавать наборы плейбуков, включающие в себя необходимые небольшие плейбуки.
Пример проверки и применения главного плейбука:
```
$ ansible-playbook site.yml --check
$ ansible-playbook site.yml
```

__Интегрируем Ansible в Packer.__

Изменим провижн образов Packer с shell-скриптов на Ansible-плейбуки. Используем плейбуки `ansible/packer_app.yml` и `ansible/packer_db.yml`.

Создадим новые установочные образы в GCP. Выполняем команды из корня репозитория. Предварительная проверка на ошибки:
```
$ packer validate -var-file=./packer/variables.json ./packer/app.json
$ packer validate -var-file=./packer/variables.json ./packer/db.json
```
Затем сборка образов:
```
$ packer bulild -var-file=./packer/variables.json ./packer/app.json
...
--> googlecompute: A disk image was created: reddit-app-base-[timestamp]


$ packer build -var-file=./packer/variables.json ./packer/db.json
...
--> googlecompute: A disk image was created: reddit-db-base-1582539156
```



### Запуск проекта


Создаем новое окружение:
```
$ terraform destroy -auto-approve
$ terraform apply -auto-approve
```

Перед проверкой ненеобходимо изменить внешние IP-адреса инстансов в инвентори файле `ansible/inventory.json` и переменную db_host в сценарии приложения `ansible/app.yml`.

Далее сначала проверяем главный плейбук:
```
$ ansible-playbook site.yml --check
```
затем применяем его:

```
$ ansible-playbook site.yml
```

### Проверка работоспособности

Приложение Reddit должно быть доступно по адресу: `http://external-app-ip:9292`.
Оно должно быть работоспособно. Можно зарегистрироваться и добавлять новые посты.



## [   HW 10: ansible-1   ]

__Основное задание.__

Установлен Ansible. Настроены параметры по умолчанию. Созданы инвентори и плэйбук для клонирования репозитория Reddit.

При первом запуске плэйбука на сервере уже существует папка назначения `~/reddit/`, куда должен скопироваться репозиторий. Поэтому в результате выполнения плэйбука мы видим, что все выполнено успешно, но никаких изменений не внесено.

Перед повторным запуском мы удаляем папку `~/reddit/`. И при выводе результата исполнения видим, что задания выполнены успешно, внесены изменения. То есть выполнена задача по клонированию репозитория.

__Задание *__

Создан bash-скрипт `inventory_dynamic.sh`. Если указать его в качестве инвентори, то он отдает в Ansible динамический json-инвентори требуемого формата. Скрипт читает IP адреса для хостов в GCP из статического json-инвентори `inventory.json`.
Никакие переменные инстансов не запрашиваем. Поэтому секция _meta ничего не содержит.

Доступность хостов проверяем командой:
```
ansible all -m ping
```
Что именно формирует скрипт инвентори проверяем:
```
./inventory_dynamic.sh --list
```



## [   HW 9: terraform-2   ]

__Основное задание.__

Создано две конфигурации для разных окружений терраформа в разных диреториях:
`terraform/stage` и `terraform/prod`.
Применение конфигурации происходит из своей поддиректории командой:

```
terraform apply
```
В результате должны быть созданы две ВМ, доступные для управления по протоколу ssh.

__Задание *__

Для обоих окружений настроим хранение state-файла в хранилище Google cloud storage.
Корзина уже создана при выполении основного задания. В файлах ENV_NAME/main.tf внесем изменения:
```
terraform {
  required_version = "0.12.19"
  backend "gcs" {
    bucket = "storage-bucket-torwel-krsk"
    prefix = "terraform/ENV_NAME"
  }
}
```

А также создадим файлы `ENV_NAME/backend.tf` с содержимым:
```
data "terraform_remote_state" "remote_state" {
  backend = "gcs"
  config = {
    bucket = "storage-bucket-torwel-krsk"
    prefix = "terraform/ENV_NAME"
  }
}
```

где ENV_NAME необходимо заменить на имя настраиваемого окружения prod/stage.

В результате после применения конфигурации state-файлы для обоих окружений будут размещены 
в хранилище GCS.



## [   HW 8: terraform-1   ]

__Основное задание.__

В директории terraform созданы файлы с кодом и переменными для Terraform'а.
Они позволяют создать экземпляр ВМ, настроить окружение и запустить приложение Reddit, 
настроить файервол. Для всего этого достаточно выполнить команды:

```
cd terraform
terraform apply
```

__Задание *__

Добавление одного ssh-ключа в метаданные проекта. Ресурс для main.tf:

```
resource "google_compute_project_metadata" "ssh_keys" {
    metadata = {
      ssh-keys = "appuser:${file("~/.ssh/appuser.pub")}"
    }
}
```

Добавление нескольких ssh-ключей в метаданные проекта. Ресурс для main.tf:

```
resource "google_compute_project_metadata" "ssh_keys" {
  metadata = {
    ssh-keys = <<EOF
      appuser1:${file("~/.ssh/appuser.pub")}
      appuser2:${file("~/.ssh/appuser.pub")}
EOF
  }
}
```

Если добавить в проект ssh-ключ через web-интерфейс, то во время применения ресурса, описывающего ключи, этот ключ будет удален.



## [   HW 7: packer-base   ]

Создан packer-шаблон ubuntu16.json. Используя его, получим ВМ с установленным Ruby и MongoDB.
Команда для создания ВМ:

```
packer build -var-file variables.json ubuntu1604.json
```

Создан packer-шаблон immutable.json. Используя его, получим ВМ с установленным окружением
и запущенным приложением Reddit.
Команда для создания ВМ:

```
packer build -var-file variables.json immutable.json
```

Файл variables.json содержит параметры для шаблонов.

Также создан скрипт `create-reddit-vm.sh`, при выполнении которого в GCP создается инстанс ВМ,
полностью готовый к работе.



## [   HW 6: cloud-testapp   ]


testapp_IP = 34.65.112.216
testapp_port = 9292

Команда для создания экземпляра ВМ с выполнением скрипта настройки
окружения и установки сервера Puma

```
gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --metadata-from-file startup-script=/home/orwel/otus-devops/torwel_infra/startup_script.sh
```



Команда для создания правила файерволла с помощью gcloud

```
gcloud compute firewall-rules create default-puma-server --allow=TCP:9292
```




## [   HW 5: cloud-bastion   ]


bastion_IP = 104.155.81.87 
someinternalhost_IP = 10.132.0.4

__Самостоятельное задание__

Подключение к someinternalhost в одну команду

```
ssh -At -i ~/.ssh/appuser appuser@104.155.81.87 ssh 10.132.0.4
```

или

```
ssh -At appuser@104.155.81.87 ssh 10.132.0.4
```



__Дополнительное задание__

Необходимо дополнить(создать) файл строками:

```
cat ~/.ssh/config
Host someinternalhost
    HostName 10.132.0.4
    User appuser
    ProxyCommand ssh -W %h:%p -i ~/.ssh/appuser appuser@104.155.81.87
```

Теперь подключиться на ВМ удаленной локальной сети
через bastion можно c помощью команды вида

```
ssh someinternalhost
```

