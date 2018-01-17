cd D:/Blog/Blog_Album && \
python tool.py && \
python upload-files-to-qiniu.py photos && \
python upload-files-to-qiniu.py min_photos/ min_photos && \
start move-to-album.bat && \
python make-json.py && \
cd D:/Blog/Blog_Source && \
git add . && \
git commit -m 'update blog' && \
git push coding master && \
git rm -r --cached D:/Blog/Blog_Source/.daocloud && \
git commit -m 'update blog' && \
git push github master