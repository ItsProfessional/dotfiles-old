#!/bin/sh

# Extract asar and rename original file
asar e /opt/discord/resources/app.asar /opt/discord/resources/app
mv /opt/discord/resources/app.asar /opt/discord/resources/app.asar.default -f

# Patch extracted asar
sed -i "s|process.resourcesPath|'/usr/share/discord/resources'|" /opt/discord/resources/app/app_bootstrap/buildInfo.js

sed -i "s|exeDir,|'/usr/share/pixmaps',|" /opt/discord/resources/app/app_bootstrap/autoStart/linux.js

sed -i "s|module.paths = \[\]|module.paths = \[process.env.HOME + '/.config/discordcanary/$pkgver/modules'\]|" /opt/discord/resources/app/app_bootstrap/requireNative.js

# Repack asar
asar p /opt/discord/resources/app /opt/discord/resources/app.asar
rm -rf /opt/discord/resources/app 


# Replace the Discord binary with a shell script that uses the system electron
mv /opt/discord/Discord /opt/discord/Discord.bak

cat <<EOT > /opt/discord/Discord
#!/bin/sh

if [ "$XDG_SESSION_TYPE" = wayland ]; then
	# Using wayland
	exec electron24 \\
		--enable-features=UseOzonePlatform \\
		--ozone-platform=wayland \\
		--enable-accelerated-mjpeg-decode \\
		--enable-accelerated-video \\
		--ignore-gpu-blacklist \\
		--enable-native-gpu-memory-buffers \\
		--enable-gpu-rasterization \\
		--enable-gpu \\
		--enable-features=WebRTCPipeWireCapturer \\
		--enable-blink-features=MiddleClickAutoscroll \\
		/opt/discord/resources/app.asar $@
else
	# Using x11
	exec electron24 \\
		--enable-accelerated-mjpeg-decode \\
		--enable-accelerated-video \\
		--ignore-gpu-blacklist \\
		--enable-native-gpu-memory-buffers \\
		--enable-gpu-rasterization \\
		--enable-gpu \\
		--enable-blink-features=MiddleClickAutoscroll \\
		/opt/discord/resources/app.asar $@
fi
EOT

chmod 755 /opt/discord/Discord


# Install vencord and openasar
clipath=/tmp/$(mktemp -u vencord-cli-XXXXXXXX)

# Download vencord cli
curl -s https://api.github.com/repos/Vencord/Installer/releases/latest \
| jq -r ".assets[] | .browser_download_url" \
| grep ".*VencordInstallerCli-linux" \
| wget -O "$clipath" -qi -

chmod a+x "$clipath"

eval "$clipath --branch stable --install-openasar"
eval "$clipath --branch stable --install"

rm -rf "$clipath"

