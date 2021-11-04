# Youtube Downloader	

##### Requirements

​	Python v3.6 or higher

​	PyTube3 v10

```
pip install pytube==10.4.1
```



##### Download Single Video (Default)

```
python youtubeDownloader.py myURLtoVideo -v
or
python youtubeDownloader.py myURLtoVideo -video
or
python youtubeDownloader.py myURLtoVideo
```

##### Download Playlist

```
python youtubeDownloader.py myURLtoPlayList -l
or
python youtubeDownloader.py myURLtoPlayList -list
```

##### Error: Cypher

 It's a problem that happened because YouTube changed their search patterns or something from cipher to signatureCipher.

1. go to the path - `C:\Users\<user>\AppData\Local\Programs\Python\Python37-32\Lib\site-packages\pytube`. Keep in mind the path will vary so replace `<user>` with your Windows username and `python37-32` with your Python version that you install pytube on.

2. open `extract.py` from the above navigated directory and head onto line 301 or search for the line:

   ```
   cipher_url = [
       parse_qs(formats[i]["cipher"]) for i, data in enumerate(formats)
   ]
   ```

   to

   ```
   cipher_url = [
        parse_qs(formats[i]["signatureCipher"]) for i, data in enumerate(formats)
   ]
   ```

   In case you damage this file while making changes to it, just say `pip uninstall pytube3` and then install it again, and repeat. Keep in mind your imports will still be `import pytube`.



##### Key Error: Asset
I believe the pypi package is broken. We're trying to get the repo owner to update the pypi package, but in the meantime, you can use python -m pip install git+https://github.com/nficano/pytube to install the most up-to-date version.