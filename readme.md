# Parallels Desktop Crack

Crack for Parallels Desktop.

- [x] Support Intel
- [ ] Support Apple Silicon (M1)
- [ ] Network
- [ ] USB


# Network & USB problem

Parallels Desktop new version use Apple's hypervisor framework vmnet API need a paid Developer ID and request to Apple enable vmnet access permission.

So i don't know how to bypass it.

Here have a temp solution:

```
killall -9 prl_client_app
sudo sed -i '' 's|<UseKextless>.*</UseKextless>|<UseKextless>0</UseKextless>|' /Library/Preferences/Parallels/network.desktop.xml
sudo sed -i '' 's|<Usb>.*</Usb>|<Usb>1</Usb>|' /Library/Preferences/Parallels/dispatcher.desktop.xml
```

After this, network will work, USB only work with storage device.


# Build

```
./scripts/build.bat
```


# Install & Test

```
sudo ./scripts/install.sh
```


# Publish DMG

```
brew install create-dmg
./scripts/publish.sh
```

You can found packaged dmg file in `publish` folder.

Good Luck!

