#!/bin/bash 
cd /Users/yanss/Documents/Blog/fakeyanss.github.io
git checkout source
#cp README.md source/README.md
git add .
git commit -m 'update blog'
git push origin source
