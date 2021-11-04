from pytube import YouTube
from pytube import Playlist
from os import path
from os import rename

import sys
import argparse
dwnld_ndx = 1

vid_dir = ''
audio_enabled = False

def progress_function( stream, chunk, bytes_remaining):

    size = stream.filesize
    p = ((size - bytes_remaining) / size) * 100.0
    print ("{:.2f}".format(p)+"%", end='\r')
        
		
def download(uri):
	global dwnld_ndx
	global vid_dir
	
	#print(uri)
	try:
		yt = YouTube(uri, on_progress_callback=progress_function)
		if ( path.exists(vid_dir+'/'+yt.title + '.mp4')):
			print("Exists : ", dwnld_ndx, yt.title)
			#print('Pass: '+vid_dir+'\/'+yt.title + '.mp4')
			pass
		else:
			print("Downloading : ",dwnld_ndx, yt.title)
			st = yt.streams.get_highest_resolution()
			st.download(vid_dir)
	except ValueError :
		print(ValueError)
		pass
	#except :
		#print("URL Error: "+ uri)

	else:
		pass
	dwnld_ndx += 1
		
def download_playlist(url):
	#print(url)
	videos = Playlist(url)
	#print (videos)
	#for video in videos:
		#print(YouTube(video).title)
	print("Number of Videos in Playlist: "+ str(len(videos)))
	for video in videos:
		if ( audio_enabled ):
			download_audio(video)
		else:
			download(video)

		
def open_file_urllist (filename):
	f = open(filename,"r")
	lines = f.readlines()
	for line in lines:
		line = line.rstrip('\r\n')
		l = '\"'+str(line)+'\"'
		download(l)

def open_Playlist ( filename ) :
	f = open(filename,"r")
	line = f.readline()
	#line = line.rstrip('\r\n')
	url = '\"'+str(line)+'\"'
	print(url)
	download_playlist(url)
	
def download_audio(uri):
	global dwnld_ndx
	global vid_dir
	
	#print(uri)
	try:
		yt = YouTube(uri)
		if ( path.exists(vid_dir+'/'+yt.title + '.mp4')):
			#print('Pass: '+vid_dir+'\/'+yt.title + '.mp4')
			pass
		else:
			print(dwnld_ndx, yt.title)
			st = yt.streams.get_audio_only()
			st.download(vid_dir)
	except:
		print("URL Error: "+ uri)
		print(ValueError)
		pass
	dwnld_ndx += 1
	
def rename_Playlist ( url ) :

	videos = Playlist(url)
	f_list = open(vid_dir+"playlist_files.txt", "at")
	i = 0
	for video in videos:
		try:
			i += 1
			yt = YouTube(video)
			f_list.write(yt.title)
			if ( path.exists(vid_dir+'\/'+yt.title + '.mp4')):
				org = vid_dir+'\/'+yt.title + '.mp4'
				nw = vid_dir+'\/'+str(i)+' '+yt.title + '.mp4'
				rename(org, nw)
			else:
				print(vid_dir+'\/'+yt.title )
				
		except:
			pass
	f_list.close()
if __name__ == "__main__":

	parser = argparse.ArgumentParser(description='Process some options.')

	parser.add_argument('-v', '--video', const=1, nargs='?', help='Specifies the url is a video(default')
	parser.add_argument('-l', '--list', const=1, nargs='?', help='Specities the usl is a video playlist')
	parser.add_argument('-d', '--directoy', const=1, nargs='?', help='Relative Path (Default: ./tmp)')
	parser.add_argument('-r', '--rename', const=1, nargs='?', help='Rename createtd file')
	parser.add_argument('-a', '--audio', const=1, nargs='?', help='Download MP4 Audio')
	parser.add_argument('url')

	args = parser.parse_args()
	#print(args)
	if(args.audio != None):
		audio_enabled = True
	else:
		audio_enabled = False
	
	if ( args.directoy != None ) :
		vid_dir = args.directoy
		#print(vid_dir)
	else:
		if (audio_enabled == True):
			vid_dir = '.\tmp\audio'
		else:
			vid_dir = '.'
		
		
	if (args.rename != None ):
		rename_Playlist(args.url)
	elif (args.list != None):
		download_playlist(args.url)
	else :
		if (audio_enabled == True):
			print("Download Audio File")
			download_audio(args.url)
		else:
			print("Download Video File")
			download(args.url)

