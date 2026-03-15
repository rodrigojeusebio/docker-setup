# How to use

1. Copy files from this directory to the root of your application directory

```bash
cp -r ./* ./../your_app_directory
```

2. Replace the string my_laravel_app with your_app_name

```bash
# Linux
grep -rl "my_laravel_app" . | xargs sed -i 's/my_laravel_app/your_app_name/g'
```

```bash
# MacOS
grep -rl "my_laravel_app" . | xargs sed -i '' 's/my_laravel_app/my_app_name/g'
```

3. Update the exposed port your docker-compose.yml

```
  - "8000:80"    # Update the 8000 port to one of your choice
```

4. Deploy your app

```bash
./deploy.sh
```