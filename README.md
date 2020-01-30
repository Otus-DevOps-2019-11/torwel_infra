# torwel_infra
torwel Infra repository



## [   HW 10: ansible-1   ]

__Основное задание.__

Установлен Ansible. Настроены параметры по умолчанию. Созданы инвентори и плэйбук для клонирования репозитория Reddit.

При первом запуске плэйбука на сервере уже существует папка назначения `~/reddit/`, куда должен скопироваться репозиторий. Поэтому в результате выполнения плэйбука мы видим, что все выполнено успешно, но никаких изменений не внесено.

Перед повторным запуском мы удаляем папку `~/reddit/`. И при выводе результата исполнения видим, что задания выполнены успешно, внесены изменения. То есть выполнена задача по клонированию репозитория.



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

