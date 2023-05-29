#!/bin/sh

if [ -e "/opt/discord/Discord.bak" ]; then
  rm -rf /opt/discord/Discord
  mv -f /opt/discord/Discord.bak /opt/discord/Discord
fi

if [ -e "/opt/discord/resources/app.asar.default" ]; then

  rm -rf /opt/discord/resources/app.asar
  rm -rf /opt/discord/resources/_app.asar
  rm -rf /opt/discord/resources/app.asar.original

  mv -f /opt/discord/resources/app.asar.default /opt/discord/resources/app.asar

elif [ -d "/opt/discord/resources/app.asar" ]; then
  # app.asar is a directory i.e. vencord is installed

  rm -rf /opt/discord/resources/app.asar

  if [ -e "/opt/discord/resources/app.asar.original" ]; then
    # openasar is also installed
    rm -rf /opt/discord/resources/_app.asar
    mv -f /opt/discord/resources/app.asar.original /opt/discord/resources/app.asar
  else
    # only vencord is installed
    mv -f /opt/discord/resources/_app.asar /opt/discord/resources/app.asar
  fi

fi

