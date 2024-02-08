# Manage Shecan DNS
If you need to change your dns constantly, this script is for you.

## How to use
Simply run the script. If the 'shecan' DNS already exists, the script will remove it and revert to your default DNS settings. If the 'shecan' DNS does not exist, the script will comments your current DNS configurations and then add the 'shecan' DNS.

1. Clone this repository.
```bash
git clone https://github.com/rastinsenobari/shecan-dns && cd shecan-dns
```

2. make executable.
```bash
sudo chmod +x ./shecan.sh
```

3. Enjoy it.
```bash
sudo ./shecan.sh
```

### Easy to use
```bash
sudo ln -fs $(pwd)/shecan.sh /usr/bin/shecan
```
Create a symbolic link for your script, enabling you to swiftly execute it with a simple command, `sudo shecan`.

### Options

| Option | Description |
| ----------- | ----------- |
| -s \| --status | Provide a summary of DNS terms  |

## Help Us
If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue. Don't forget to give the project a star! Thanks again!
