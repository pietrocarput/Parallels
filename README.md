<div align="center">
   <img src="https://github.com/trueToastedCode/ParallelsLab/assets/44642574/e05554fe-b335-42dc-87d6-7a3780916706" width=128 height=128>
   <h1>Parallels Desktop Crack</h1>
   <div>19.1.0-54729</div>
</div><br><br>
✅ ARM64<br>
✅ x86_64<br>
✅ Network<br>
✅ USB<br>
✅ System Integrity Protection (SIP)<br>
✅ No additional launcher<br><br>

## Disclaimer
The use of software cracks for illegal purposes is strictly prohibited and we encourage the legal purchase and use of the software. By using this software or reading this disclaimer, you acknowledge that you understand the importance of legal software usage and that you will not use software cracks or engage in illegal activities related to software.

## Usage
1. [Install Parallels Desktop](https://download.parallels.com/desktop/v19/19.1.0-54729/ParallelsDesktop-19.1.0-54729.dmg)<br>
2. Sign out your'e account
3. Install [Xcode from the App Store](https://apps.apple.com/us/app/xcode/id497799835?mt=12)<br>
   Open it afterwards and install the default components (iOS and MacOS, which cannot be unchecked)
4. `git submodule update --init --recursive && chmod +x install.sh && chmod +x reset.command && sudo ./install.sh`

## Donation
<img src="https://github.com/trueToastedCode/ParallelsLab/assets/44642574/8a7a724b-4fed-4f68-8660-e475587d34fd" width=96><br><br>
Do you want to express gratitude for our reverse engineering efforts?

### [[ PayPal ] trueToastedCode](https://paypal.me/trueToastedCode)
Involved in versions 18.3 - 19.1

### [[ PayPal ] alsyundawy](https://paypal.me/alsyundawy)
Involved in versions 18.0 - 18.1

### [[ GitHub ] QiuChenly](https://github.com/QiuChenly)
Inspired trueToastedCode on dylib-injections in 19.1

## Sidenotes
### ⚠ Don't fully quit and reopen Parallels very quickly ⚠
*It's automatically resetting the crack using hooked functions but this may break it*

### 🔧 In case you're crack stops working 🔧
Reset it using \"reset.command\"

### Issues
[Report issues here](https://github.com/trueToastedCode/ParallelsLab/issues)

### Operation not permitted
Enable `System Preferences ▸ Privacy & Security ▸ Full Disk Access ▸ Terminal`
### codesign error
Ensure xcode command line tools installed. Install it with using the command `xcode-select --install`.

Check installation with `xcode-select -p`, which will output `/Library/Developer/CommandLineTools` or `/Applications/Xcode.app/Contents/Developer`.
## Hosts
You also wan't to block Parallels Servers.
```
127.0.0.1 download.parallels.com
127.0.0.1 update.parallels.com
127.0.0.1 desktop.parallels.com
127.0.0.1 download.parallels.com.cdn.cloudflare.net
127.0.0.1 update.parallels.com.cdn.cloudflare.net
127.0.0.1 desktop.parallels.com.cdn.cloudflare.net
127.0.0.1 www.parallels.cn
127.0.0.1 www.parallels.com
127.0.0.1 www.parallels.de
127.0.0.1 www.parallels.es
127.0.0.1 www.parallels.fr
127.0.0.1 www.parallels.nl
127.0.0.1 www.parallels.pt
127.0.0.1 www.parallels.ru
127.0.0.1 www.parallelskorea.com
127.0.0.1 reportus.parallels.com
127.0.0.1 parallels.cn
127.0.0.1 parallels.com
127.0.0.1 parallels.de
127.0.0.1 parallels.es
127.0.0.1 parallels.fr
127.0.0.1 parallels.nl
127.0.0.1 parallels.pt
127.0.0.1 parallels.ru
127.0.0.1 parallelskorea.com
127.0.0.1 pax-manager.myparallels.com
127.0.0.1 myparallels.com
127.0.0.1 my.parallels.com
```
Parallels Desktop will uncomment these, therefore one needs to lock the hosts file:<br>
`sudo chflags uchg /etc/hosts && sudo chflags schg /etc/hosts`<br>
Unlock:<br>
`sudo chflags nouchg /etc/hosts && sudo chflags noschg /etc/hosts`
### OS download
You will not be able to download operating systems in the Control Center anymore. Comment these out to get this functionality:
```
# 127.0.0.1 download.parallels.com
# 127.0.0.1 desktop.parallels.com
# 127.0.0.1 download.parallels.com.cdn.cloudflare.net
# 127.0.0.1 desktop.parallels.com.cdn.cloudflare.net
```
<br><br>
<a href="https://www.flaticon.com/free-icons/heart" title="heart icons">Heart icons created by Freepik - Flaticon</a>
