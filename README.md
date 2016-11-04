# Docker ZEC Container

[![](https://images.microbadger.com/badges/image/monachus/zcash.svg)](https://microbadger.com/images/monachus/zcash "Get your own image badge on microbadger.com")

I built this container so that I could run ZCash functions under OSX
(namely to have access to my wallet).

It follows the [Debian installation guide](https://github.com/zcash/zcash/wiki/Debian-binary-packages)
and will launch the `zcash` daemon on boot. If you don't set the environment
up first, this will fail.

## Pulling from Docker Hub

You can pull the latest copy of this container from [Docker Hub](https://hub.docker.com/r/monachus/zcash/)
by running:
```
$ docker pull monachus/zcash
```

## Building the Container

Building the container is easy:
```
$ docker build -t monachus/zcash .
```

## Setting Up The Environment

### Initialize Configuration File

Although the container is configured to use a persistent volume for
`~root/.zcash` and `~root/.zcash-params`, I recommend that you designate exactly
_where_ that volume lives so that you can run backups and have better control
over the data. For this document we'll assume that you're using `~/.zcash` on
the Docker host.

First, create this directory and then create your `zcash.conf` file according
to [these instructions](https://github.com/zcash/zcash/wiki/1.0-User-Guide#configuration).
```
$ mkdir ~/.zcash
$ echo "addnode=mainnet.z.cash" >~/.zcash/zcash.conf
$ echo "rpcuser=username" >>~/.zcash/zcash.conf
$ echo "rpcpassword=`head -c 32 /dev/urandom | base64`" >>~/.zcash/zcash.conf
```

Enable CPU mining, if you wish:
```
$ echo 'gen=1' >> ~/.zcash/zcash.conf
$ echo "genproclimit=$(nproc)" >> ~/.zcash/zcash.conf
```

Everyone seems to be on the `tromp` wagon these days:
```
$ echo 'equihashsolver=tromp' >> ~/.zcash/zcash.conf
```

### Pull down the initial proving and verification keys

If this is your first run, you'll need to retrieve the keys, which are
currently around 900MB in size.
```
docker run -v ~/.zcash:/root/.zcash -v ~/.zcash-params:/root/.zcash-params -it monachus/zcash zcash-fetch-params
```

### Start up the daemon

At this point you should be able to run the container manually, or using the
provided `docker-compose.yml` file.  If you run the container manually, I
recommend that you give it a name for easy interaction.
```
$ docker run --name zcash -v ~/.zcash:/root/.zcash -v ~/.zcash-params:/root/.zcash-params monachus/zcash
```

(Add `-d` to run the container in detached mode.)
This will fire up the daemon and (optionally) start CPU mining with your hardware.

Once you have the daemon running, you can continue with creating a wallet and
conducting transactions. You need only use `docker exec` to interact with the
running container.
```
$ docker exec zcash zcash-cli getpeerinfo
```

And so on.

Happy mining!

If you want to toss me some ZEC as a donation, you can send it to
`zcX6hXED6gNDgCp6CSLtgjBQEJoqSey2wqhJjZi6mX3a6CVhVj1GQ4yRvWCyVCQP61urzb2iGYGZFMNdMKQb6rL8Ro9KjdG`.
