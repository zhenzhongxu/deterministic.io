# deterministic.io
www.deterministic.io

Prerequisits:
* install Vagrant [https://www.vagrantup.com/]
* install other necessary plugins (run this once) <br/>
```./bin/init.sh```

To deploy to remote aws instance:<br/>
```vagrant up --provider=virtualbox```

To deploy to local virtualbox:<br/>
```source ./local/secretes.sh && vagrant up --provider=aws```
