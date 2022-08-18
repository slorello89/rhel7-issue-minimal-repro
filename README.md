# RHEL7 cipher suite minimal reproduction

Note: in spite of it's name this does not actually use RHEL7, it uses an ubuntu base and simply reconfigures Redis' acceptable cipher suites to be highly restrictive to a couple of relatively insecure ciphers, this is meant simply to demonstrate the .NET 5+ cipher suite issue

## Running

1. Spin up the redis-enterprise container, and set it's cipher-suite configuration, just run the `spin_containers.bash` file, this should get everything up and running for you
1. Grep the containers ip-address `docker inspect rp | grep IPAddress`, save this.
1. At this point, if you simply run this project with `dotnet run --project TestRHELdotnet6/TestRHELdotnet6.csproj`, you'll see a couple of cert-chain errors (the certs are self signed so it doesn't trust the CA, but we simply blow past them), but otherwise this will work
1. If you build the associated docker image `docker build . -t testrhel6` and then run the docker container with your re image's ip address `docker run --env rp_ip=<ip_address> testrhel6`