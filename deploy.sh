git branch -f master
git checkout master
git reset --hard origin/develop
npm run build
cp -r public/* .
echo '0xc0d3.pw' > CNAME
git add -A .
git commit -a -m 'site update'
git push origin master --force
git checkout develop
git rev-parse --abbrev-ref HEAD
