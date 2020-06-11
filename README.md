## docker build
docker build . -t tinc:latest 
docker push tinc:latest 

## docker build multiarch 
docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t tinc:latest --push .

## docker build inspect
docker buildx imagetools inspect tinc:latest 

## docker setup
docker pull tinc:latest 
docker tag tinc:latest  zetanova/tinc

docker volume create tinc
docker run --rm -it --volume tinc:/etc/tinc zetanova/tinc --generate-keys
//todo add the tinc config to volume

docker run --rm -it --volume tinc:/etc/tinc busybox chmod +x /etc/tinc/tinc-up /etc/tinc/tinc-down


### firewall centos
firewall-cmd --permanent --zone=public --add-port=655/tcp 
firewall-cmd --permanent --zone=public --add-port=655/udp 

## docker run dedicated
### bash
```
docker run -it -d \
    --name tinc \
    --restart=always \
    --net=host \
    --device=/dev/net/tun \
    --cap-add NET_ADMIN \
    --volume tinc:/etc/tinc \
    zetanova/tinc
```
### powershell
```
docker run --rm -it -d ^
    --name tinc ^
    --restart=always ^
    --net=host ^
    --device=/dev/net/tun ^
    --cap-add NET_ADMIN ^
    --volume tinc:/etc/tinc ^
    tinc:latest
```

#docker disbale autostart
docker update --restart=no

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



