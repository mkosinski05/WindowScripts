from pytube import YouTube
from pytube import Playlist
import sys

url = sys.argv[1]

videos = Playlist(url)
for video in videos: 
	yt = YouTube(video)
	print(yt.title)