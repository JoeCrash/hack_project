#!/bin/sh
EXPECTED_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]
then
    >&2 echo 'ERROR: Invalid installer checksum'
    rm composer-setup.php
    exit 1
fi

php composer-setup.php --quiet
RESULT=$?
rm composer-setup.php
php composer.phar update
>&2 echo 'SUCCESS: Composer downloaded & updated'

mkdir bin src tests
>&2 echo '/bin, /src & /tests created'

curl https://raw.githubusercontent.com/hhvm/hhast/master/.hhconfig > .hhconfig
>&2 echo 'hhconfig downloaded'

cat <<'EOF' > hh_autoload.json
{
  "roots": [
    "src/"
  ],
  "devRoots": [
    "tests/"
  ],
  "devFailureHandler": "Facebook\\AutoloadMap\\HHClientFallbackHandler"
}
EOF

>&2 echo 'hh_autoload.json created'

composer require hhvm/hsl hhvm/hhvm-autoload
composer require --dev hhvm/hhast hhvm/hacktest facebook/fbexpect
>&2 echo 'composer common dependencies added'

exit $RESULT