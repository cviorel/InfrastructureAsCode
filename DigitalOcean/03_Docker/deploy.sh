#!/usr/bin/env bash
DOMAIN=custd.co


for i in {0..4}
do
  number=$(printf %02d $i)
  declare "DO${number}=$(dig +short do${number}.${DOMAIN})"
  declare "iDO${number}=$(dig +short ido${number}.${DOMAIN})"
  alias "do${number}"='eval  $(docker-machine env do'${number}')'
  alias "rdo${number}"='ssh root@do'${number}'.${DOMAIN}'
done


for i in {0..4}
do
  number=$(printf %02d $i)
  delSSHHost 'do'${number}'.${DOMAIN}'
  delSSHHost "$(dig +short do${number}.${DOMAIN})"
done


for i in {0..4}
do
  number=$(printf %02d $i)
  docker-machine rm -y "do${number}"
  docker-machine create \
    --driver generic \
    --engine-storage-driver overlay2 \
    --generic-ip-address="do${number}.${DOMAIN}" \
    --engine-install-url=https://get.docker.com/ \
    --generic-ssh-user=root "do${number}" &
done

#for i in {0..4}
#do
#  number=$(printf %02d $i)
#  ssh -o StrictHostKeyChecking=no root@do${number}.${DOMAIN} reboot
#done

do00
docker swarm init --advertise-addr "${iDO00}:2377"

WORKER_TOKEN=$(docker swarm join-token -q worker)
MANAGER_TOKEN=$(docker swarm join-token -q manager)

echo "WORKER_TOKEN=${WORKER_TOKEN}
MANAGER_TOKEN=${MANAGER_TOKEN}"

do01
docker swarm join --advertise-addr ${iDO01}:2377 --token ${WORKER_TOKEN} ${iDO00}:2377

do02
docker swarm join --advertise-addr ${iDO02}:2377 --token ${WORKER_TOKEN} ${iDO00}:2377

do03
docker swarm join --advertise-addr ${iDO03}:2377 --token ${WORKER_TOKEN} ${iDO00}:2377

do04
docker swarm join --advertise-addr ${iDO04}:2377 --token ${MANAGER_TOKEN} ${iDO00}:2377

do00

docker node ls

docker network create --driver overlay postgres

docker node update --label-add type=master do02

#docker node inspect do02 --format='{{.Spec.Labels}}'

docker service create \
  --mount type=volume,src=pgmaster-volume,dst=/var/lib/postgresql/data,volume-driver=local \
  --name pgmaster \
  --network postgres \
  --constraint 'node.labels.type == master' \
  --env NODE_ID=1 \
  --env NODE_NAME=node1 \
  --env CLUSTER_NODE_NETWORK_NAME=pgmaster \
  --env POSTGRES_PASSWORD=monkey_pass \
  --env POSTGRES_USER=monkey_user \
  --env POSTGRES_DB=monkey_db \
  --env CONFIGS="listen_addresses:'*'"\
  --env CLUSTER_NAME=pg_cluster \
  --env REPLICATION_DB=replication_db \
  --env REPLICATION_USER=replication_user \
  --env REPLICATION_PASSWORD=replication_pass \
  --publish 15432:5432 \
  paunin/postgresql-cluster-pgsql

docker service ls
docker service ps pgmaster

docker node update --label-add type=slave02 do03
docker node update --label-add type=slave03 do04


docker service create \
  --mount type=volume,src=pgslave2-volume,dst=/var/lib/postgresql/data,volume-driver=local \
  --name pgslave2 \
  --network postgres \
  --env REPLICATION_PRIMARY_HOST=pgmaster \
  --constraint 'node.labels.type == slave02' \
  --env NODE_ID=2 \
  --env NODE_NAME=node2 \
  --env CLUSTER_NODE_NETWORK_NAME=pgslave2 \
  --publish 25432:5432 \
  paunin/postgresql-cluster-pgsql

docker service create \
  --mount type=volume,src=pgslave3-volume,dst=/var/lib/postgresql/data,volume-driver=local \
  --name pgslave3 \
  --network postgres \
  --env REPLICATION_PRIMARY_HOST=pgmaster \
  --constraint 'node.labels.type == slave03' \
  --env NODE_ID=3 \
  --env NODE_NAME=node3 \
  --env CLUSTER_NODE_NETWORK_NAME=pgslave3 \
  --publish 35432:5432 \
  paunin/postgresql-cluster-pgsql

#docker service rm pgpool

docker service create \
  --mount type=volume,src=pgslave3-volume,dst=/var/lib/postgresql/data,volume-driver=local \
  --name pgpool \
  --replicas 3 \
  --network postgres \
  --env PCP_USER=pcp_user \
  --env PCP_PASSWORD=pcp_pass \
  --env DB_USERS=replication_user:replication_pass  \
  --env BACKENDS="0:pgmaster:5432:1:/var/lib/postgresql/data:ALLOW_TO_FAILOVER,2:pgslave2::::,3:pgslave3::::"  \
  --env CONFIGS="num_init_children:250,max_pool:4"  \
  --publish 5432:5432 \
  --publish 9898:9898 \
  paunin/postgresql-cluster-pgpool

docker service create \
  --name web \
  --replicas 3 \
  --network postgres \
  --publish 80:3000 \
  timhaak/iac-demo /usr/bin/yarn start

#docker service create \
#    --name pingtest \
#    --replicas 1 \
#    --network postgres \
#     alpine:edge ping www.google.com
