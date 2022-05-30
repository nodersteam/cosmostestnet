In this guide, we wrote how to set up a bot to track jail of the nodes of the cosmos ecosystem and autounjail

To install, follow a few simple steps:

Run the script, select the installation stage, which will ask you to enter the NodeName, API_token,and telegram chat id.
```php
curl -s https://raw.githubusercontent.com/nodersteam/cosmostestnet/main/tgbotjail/parametrs > parametrs.sh && chmod +x parametrs.sh && ./parametrs.sh
```

Select the "Start bot" item and enter the following data in the line that appears, you also need to leave the next line empty

```php
*/1 * * * *  /bin/bash $HOME/tgbotjail/start.sh
```
