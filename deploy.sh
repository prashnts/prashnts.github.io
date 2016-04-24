git branch -f master
git checkout master
git reset --hard origin/develop
git add -A .
git commit -a -m 'site update'
git push origin master --force
git checkout master
git rev-parse --abbrev-ref HEAD
