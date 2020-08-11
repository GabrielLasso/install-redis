# install-redis

Script para configurar uma instância _stable_ do Redis.

## Requisitos

_Debian_(testado) ou _Ubuntu_ (não testado).

## Instruções

Assim que tiver uma nova instância:

```
sudo apt update && sudo apt upgrade
sudo apt install git
git clone https://github.com/Delivery-Direto/install-redis.git
cd install-redis
./install-redis.sh
```

Será pedido para digitar uma senha. Após isso o processo já deve iniciar.

## Configuração

Caso seja necessário editar as configurações, edite o arquivo `/etc/redis/6379.conf`.
As principais configurações são:
```
maxmemory 14gb                              # o máximo de memória a ser usado
requirepass {{PASSWORD}}                    # a senha a ser usada
dir /var/lib/redis/6379                     # pasta onde ficam os dados
dbfilename dump.rdb                         # nome do arquivo
maxmemory-policy allkeys-lru                # estratégia de liberar memória
logfile /var/lib/redis/log/redis-server.log # arquivo de log
save 900 1000                               # frequência de salvar no disco
```

## Comandos

Para gerenciar o processo, basta usar o `systemctl`
```
sudo systemctl start redis
sudo systemctl status redis
sudo systemctl stop redis
sudo systemctl restart redis
```

Para verificar o log:
```
tail -f /var/lib/redis/log/redis-server.log
```

Para conectar:
```
redis-cli -a PASSWORD
```

### Referências

- https://github.com/redis/redis/issues/6370
- https://serverfault.com/questions/893066/redis-not-starting-with-systemctl
- https://unix.stackexchange.com/questions/99154/disable-transparent-hugepages
- https://github.com/docker-library/redis/issues/35
