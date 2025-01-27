## filtreye göre bütün image silme komutu
docker rmi $(docker images --filter reference=alpine -q)
