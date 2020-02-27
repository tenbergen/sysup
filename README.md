# sysup
A tool to report IP addresses of headless machines to a public server. This is useful when, e.g., you run Raspberry Pis in headless mode for student projects, but your university network recycles DHCP IP addresses often. In fact, this script is mainly meant for Raspberry Pi applications.

## Prerequisites
You will require a public server to which to report IP addresses to. That server must be different from the headless device that does the reporting.
On that server, you either have to have access to a web folder or have SSH access. On the headless device, you should have root access to add `sysup` as a service, but you can also run it using a user cron.

## Installation

Execute on your headless device:
```
git clone https://github.com/tenbergen/sysup.git
cd sysup
sudo cp sysup.service /etc/systemd/system/
```

Then proceed as follows:

### Web Mode
If you want sysup to post to a website, copy both *.php files to a web folder:
```
scp *.php user@example.com:~/public_html/
```

Open `sysup.sh` and uncomment the following lines by removing the `#` character:
```
urlmessage=$(echo $message | sed -r 's/ /+/g')
curl -m 2 "http://example.com/~user/sysupload.php?host=$hostname&data=$urlmessage"
```
Edit the URL to be posted to according to your needs.

### SSH Mode
If you want sysup to post to an ssh server, generate a keypair for password-less login and copy your public key to the server:
```
ssh-keygen
ssh-copy-id user@example.com
```
It will prompt you for a password.

Open `sysup.sh` and uncomment the following line by removing the `#` character:
```
ssh user@example.com "echo $message > ~/public_html/sysup/$hostname.txt"
```

### Start the service
To start the service, simply run:
```
sudo systemctl enable sysup.service
```

### Using crontab
You can also add `sysup` to your crontab without root access:
```
crontab -e
```
add the following line to the end of the file:
```
@reboot /home/pi/sysup/sysup.sh >> /home/pi/sysup/sysup.log 2>$1
```
Note, that `sysup` uses an infinite loop and crontab doesn't like it.

### Non-Raspberry Pi usage
You can use this script on machines other than Raspberry Pi, but you may need to modify paths in `sysup.sh` and `sysup.service` to suit your needs.

## Contribute
Share the love and improve this thing. I'm sure there's plenty ways to make it better. My main concern is making somehting easy to use and versatile.
