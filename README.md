# factorio-server-scripts
Setup & scripts assume [factorio/](factorio) directory is cloned into user home directory.

## Crontab setup
Run [update-factorio.sh](factorio/update-factorio.sh) script on a schedule.

Open crontab editor:
````shell
crontab -e
````
Paste into editor:
(update timings if needed)
````shell 
# run update-factorio script every 5 min, between 08:00-23:55
*/5 8-23 * * * ~/factorio/update-factorio.sh

# clear update-factorio logs older than 7 days; runs daily at 00:00
0 0 * * * find ~/factorio/logs -type f -mtime +7 -exec rm {} \;
````

## Bash aliases setup
Add aliases in `.bashrc`, or in a config file sourced by `.bashrc` (like `.bash_aliases`).

Paste into editor:
(update script location if needed)
````shell
alias update-factorio='~/factorio/update-factorio.sh'
````

## Resources
- https://github.com/factoriotools/factorio-docker
- https://crontab.guru/