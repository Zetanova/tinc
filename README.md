## docker build
docker build . -t tinc:latest 
docker push tinc:latest 

## docker build multiarch 
docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t tinc:latest --push .

## docker build inspect
docker buildx imagetools inspect tinc:latest 

## docker setup
```
docker volume create tinc
docker run --rm -it --volume tinc:/etc/tinc zetanova/tinc:latest --generate-keys
docker run --rm -it --volume tinc:/etc/tinc alpine /bin/cat /etc/tinc/rsa_key.pub

#from admin host
#create/update tinc.conf
#create/update hosts/newnode
#create/update tinc-up and tinc-down

#create container 
docker create -it \
    --name tinc \
    --restart=always \
    --net=host \
    --device=/dev/net/tun \
    --cap-add NET_ADMIN \
    --volume tinc:/etc/tinc \
    zetanova/tinc:1.0.36

#add config from admin host
tar -f newnode.tar -r tinc.conf tinc-up tinc-down hosts\newnode hosts\remotenode2 hosts\remotenode2
type newnode.tar | ssh admin@newnode sudo docker cp - tinc:/etc/tinc/
ssh admin@newnode sudo docker exec tinc /bin/chmod u+x /etc/tinc/tinc-up /etc/tinc/tinc-down
ssh admin@newnode sudo docker start tinc


#add hosts/newnode to remotehost
tar -f remotehost_hosts.tar -C hosts -r newnode
type remotehost_hosts.tar | ssh remotehost docker cp - tinc:/etc/tinc/hosts/
ssh remotehost docker kill --signal=HUP tinc

#update tinc config
tar -f remotehost_conf.tar -r tinc.conf
type remotehost_conf.tar | ssh remotehost docker cp - tinc:/etc/tinc/hosts/
ssh remotehost docker kill --signal=HUP tinc


```

### firewall centos
firewall-cmd --permanent --zone=public --add-port=655/tcp 
firewall-cmd --permanent --zone=public --add-port=655/udp 

### firewall debian/ubuntu
ufw allow 655

## docker run dedicated
```
docker run -it -d \
    --name tinc \
    --restart=always \
    --net=host \
    --device=/dev/net/tun \
    --cap-add NET_ADMIN \
    --volume tinc:/etc/tinc \
    zetanova/tinc:1.0.36

#to disbale autostart
docker update --restart=no
```

## to disable autostart
```
docker update --restart=no
```

## docker control
1. reload
`docker kill --signal=HUP tinc`
2. force reconnect to all
`docker kill --signal=ALRM tinc`
3. dump connection list to log
`docker kill --signal=USR1 tinc`
4. dump all known network to log
`docker kill --signal=USR2 tinc`
5. set debug level 0-5
`docker kill --signal=0 tinc`

## docker debug
```
docker kill --signal=2 tinc
docker logs tinc -f
```


