# Parallels Desktop

Crack for Parallels Desktop 18.0.2 53077

- [x] Support Intel
- [x] Support Apple Silicon (M1 & M2)
- [x] Network
- [x] USB

# Usage

1. Install Parallels Desktop.

    https://download.parallels.com/desktop/v18/18.0.2-53077/ParallelsDesktop-18.0.2-53077.dmg

2. Exit parallels account.

3. Download this repo files.

4. Extract and run Terminal in this directory.

5. `chmod +x ./install.sh && sudo ./install.sh`

If you got "Operation not permitted" error, enable "Full Disk Access" permission for your Terminal app.

`System Preferences ▸ Security & Privacy ▸ Privacy ▸ Full Disk Access`


# Manual

1. Open `Parallels Desktop` and exit your account.

2. Exit `Parallels Desktop`.

3. Ensure prl_disp_service not running.

```
pkill -9 prl_disp_service
```

4. Copy cracked `prl_disp_service` file.

```
sudo cp -f prl_disp_service "/Applications/Parallels Desktop.app/Contents/MacOS/Parallels Service.app/Contents/MacOS/prl_disp_service"
sudo chown root:wheel "/Applications/Parallels Desktop.app/Contents/MacOS/Parallels Service.app/Contents/MacOS/prl_disp_service"
sudo chmod 755 "/Applications/Parallels Desktop.app/Contents/MacOS/Parallels Service.app/Contents/MacOS/prl_disp_service"
```

5. Copy fake licenses.json.

```
sudo cp -f licenses.json "/Library/Preferences/Parallels/licenses.json"
sudo chown root:wheel "/Library/Preferences/Parallels/licenses.json"
sudo chmod 444 "/Library/Preferences/Parallels/licenses.json"
sudo chflags uchg "/Library/Preferences/Parallels/licenses.json"
sudo chflags schg "/Library/Preferences/Parallels/licenses.json"
```

6. Sign `prl_disp_service` file.

```
sudo codesign -f -s - --timestamp=none --all-architectures --entitlements ParallelsService.entitlements "/Applications/Parallels Desktop.app/Contents/MacOS/Parallels Service.app/Contents/MacOS/prl_disp_service"
```


# Notice

Parallels Desktop may upload client info or logs to server.

You can use a firewall, hosts or custom DNS block there domains.

## Hosts

```
127.0.0.1 download.parallels.com
127.0.0.1 update.parallels.com
127.0.0.1 desktop.parallels.com
127.0.0.1 download.parallels.com.cdn.cloudflare.net
127.0.0.1 update.parallels.com.cdn.cloudflare.net
127.0.0.1 desktop.parallels.com.cdn.cloudflare.net
127.0.0.1 www.parallels.cn
127.0.0.1 www.parallels.com
127.0.0.1 reportus.parallels.com
127.0.0.1 parallels.com
127.0.0.1 parallels.cn
127.0.0.1 pax-manager.myparallels.com
127.0.0.1 myparallels.com
127.0.0.1 my.parallels.com
```

Parallels Desktop will uncomment hosts file, can use this command lock your hosts file:

```
sudo chflags uchg /etc/hosts
sudo chflags schg /etc/hosts
```

## AdGuardHome

Add the following rules to your `Custom filtering rules`:

```
||myparallels.com^$important
||parallels.cn^$important
||parallels.com^$important
||parallels.com.cdn.cloudflare.net^$important
```


# FAQ

## Why `prl_disp_service` file so big?

It's direct patch'd file for original `prl_disp_service` file.

## Is this crack safe?

It's opensource, you can use any hex file comparison tool you like open `prl_disp_service` to see what has been modified.

## I want to crack it myself.

Check the `prl_disp_service.md` to see how I cracked it.

## Where to get update?

[https://icrack.day/pdfm](https://icrack.day/pdfm)
