@echo off
REM WP Single site setup.
SET ADMIN_EMAIL="someone@domain.com"
SET URL="projectname.local"
SET TITLE="Project Name"
SET REPO="git@bitbucket.org:teamname/projectname.git"

if exist "./wordpress/wp-config.php" (
	echo "WordPress config file found."
) else (
	echo "Cloning project"
	git clone %REPOSITORY% "wordpress"
	echo "WordPress config file not found. Installing..."
	REM wp core download
	docker-compose exec --user www-data phpfpm wp core download
	REM wp core config
	docker-compose exec --user www-data phpfpm wp core config --dbhost=mysql --dbname=wordpress --dbuser=root --dbpass=password
	echo " * Setting up \"%TITLE%" at %URL%"
	docker-compose exec --user www-data phpfpm wp core install --url="%URL%" --title="%TITLE%" --admin_user=admin --admin_password=password --admin_email="%ADMIN_EMAIL%"
	docker-compose exec --user www-data phpfpm wp db create --url="%URL%" --path="wordpress"
	echo "Updating WordPress"
	docker-compose exec --user www-data phpfpm wp core update
	docker-compose exec --user www-data phpfpm wp core update-db
	echo "add %URL% to hosts file (C:\Windows\System32\Drivers\etc\hosts)"
	echo "All done!"
)