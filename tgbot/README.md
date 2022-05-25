In this guide, we wrote how to set up a bot to track the state of the nodes of the cosmos ecosystem

To install, follow a few simple steps:

Create a bot, get an api token (To get a token, you can use FatherBot in telegram) and a telegram chat id, you can read how to do it at the link - (ENG) (RU)
Run the script, select the installation stage, which will ask you to enter the NodeName, API_token,and telegram chat id.

```curl -s https://raw.githubusercontent.com/nodersteam/cosmostestnet/main/tgbot/parametrs > parametrs.sh && chmod +x parametrs.sh && ./parametrs.sh```

Select the "Start bot" item and enter the following data in the line that appears, you also need to leave the next line empty

```*/1 * * * *  /bin/bash $HOME/tgbot/alerts.sh```
