# factorio-server-scripts

## Crontab setup
Run update-factorio script on a schedule.
````shell
$ crontab -e
````
Paste into editor:
````shell 
# run update-factorio script every 5 min, between 0800-2355
*/5 8-23 * * * ~/factorio/update-factorio.sh

# clear update-factorio logs older than 7 days
0 0 * * * find ~/factorio/logs -type f -mtime +7 -exec rm {} \;
````

## Resources
- https://github.com/factoriotools/factorio-docker
- https://crontab.guru/