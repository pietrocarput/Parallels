# Parallels Desktop Crack

Crack for Parallels Desktop 18.0.1-53056

- [x] Support Intel
- [x] Support Apple Silicon (M1)
- [x] Network
- [x] USB

# Usage

run install.sh

# Manual

1. Exit Parallels Desktop

```
killall -9 prl_client_app
killall -9 prl_disp_service
```

2. Copy crack file

```
sudo cp -f prl_disp_service "/Applications/Parallels Desktop.app/Contents/MacOS/Parallels Service.app/Contents/MacOS/prl_disp_service"
```

3. Copy licenses.json

```
sudo echo '{"license":"{\\"product_version\\":\\"18.*\\",\\"edition\\":2,\\"platform\\":3,\\"product\\":7,\\"offline\\":true,\\"cpu_limit\\":32,\\"ram_limit\\":131072}"}' > "/Library/Preferences/Parallels/licenses.json"
```

4. Sign

```
sudo codesign -f -s - --timestamp=none --all-architectures --entitlements ParallelsService.entitlements "/Applications/Parallels Desktop.app/Contents/MacOS/Parallels Service.app/Contents/MacOS/prl_disp_service"
```
