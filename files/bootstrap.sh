set -e

VERSION=$1;

echo "Download Concourse ${VERSION}"
wget "https://github.com/concourse/concourse/releases/download/v${VERSION}/concourse_linux_amd64" \
 -q --show-progress  --progress=bar:force
echo "Download Fly ${VERSION}"
wget "https://github.com/concourse/concourse/releases/download/v${VERSION}/fly_linux_amd64" \
 -q --show-progress --progress=bar:force

chmod +x ./concourse* ./fly*

sudo cp ./concourse* /usr/local/bin/concourse
sudo cp ./fly* /usr/local/bin/fly

ci=`concourse --version`
cli=`fly --version`

if [ -z "${ci}" ];then
    echo "Concourse not Found"
    exit 1
else
   echo "Concourse version: ${ci}"
fi

if [ -z "${cli}" ];then
    echo "Fly Cli Not found"
    exit 1
else
   echo "Fly version: ${cli}"
fi

sudo apt-get -qq update
sudo apt-get -y -qq install postgresql postgresql-contrib

user=`id -u postgres`

if [ -z "${user}" ];then
    echo "User 'postgres' not Found"
    exit 1
else
   echo "Postgres user id: ${user}"
fi

user=__PSQL_USER__

sudo -u postgres psql <<SQL
  create user ${user} password '__PSQL_PASSWORD__';
  CREATE DATABASE atc OWNER ${user};
SQL

sudo adduser --system --group ${user}

# move all the files to right destinations
sudo mv /tmp/concourse.service  /etc/systemd/system/concourse.service
sudo chown -R root:root /etc/systemd/system/concourse.service

sudo mkdir -p /etc/concourse
sudo mv /tmp/concourse.environment  /etc/concourse/environment
sudo chown -R concourse:concourse /etc/concourse/environment

sudo mv /tmp/concourse.start.sh /usr/bin/concourse.start.sh
sudo chown -R concourse:concourse  /usr/bin/concourse.start.sh
chmod +x /usr/bin/concourse.start.sh

echo "===========CONCOURSE.SERVICE=============="
cat /etc/systemd/system/concourse.service
echo "===========CONCOURSE.ENVIRONMENT=============="
cat /etc/concourse/environment
echo "===========Bootstrap=============="
cat /usr/bin/concourse.start.sh
