#!/bin/sh

#****************************************************************************** 
#****************************************************************************** 
#
#            Plex DVR Post Processing w/Handbrake (H.264) Script
#
#****************************************************************************** 
#****************************************************************************** 
#  
#  Version: 1.0
#
#  Pre-requisites: 
#     HandBrakeCLI
#
#
#  Usage: 
#     'PlexPostProc.sh %1'
#
#  Description:
#      My script is currently pretty simple.  Here's the general flow:
#
#      1. Creates a temporary directory in the home directory for 
#      the show it is about to transcode.
#
#      2. Uses Handbrake (could be modified to use ffmpeg or other transcoder, 
#      but I chose this out of simplicity) to transcode the original, very 
#      large MPEG2 format file to a smaller, more manageable H.264 mp4 file 
#      (which can be streamed to my Roku boxes).
#
#	   3. Copies the file back to the original filename for final processing
#
#****************************************************************************** 

#****************************************************************************** 
#  Do not edit below this line
#****************************************************************************** 

fatal() {
   echo "[FATAL] $1.";
   echo "[FATAL] Program is now exiting.";
   rm -vf "$FILENAME"
   sleep 20
   exit 1;
}
# The above is a simple function for handeling fatal erros. (It outputs an error, and exits the program.)

if [ -n "$1" ]; then
# The if selection statement proceeds to the script if $1 is not empty.
   if [ ! -f "$1" ]; then 
      fatal "$1 does not exist"
   fi
   # The above if selection statement checks if the file exists before proceeding. 
   
   FILENAME=$1 	# %FILE% - Filename of original file

   #TEMPFILENAME="$(mktemp)"  # Temporary File for transcoding

   # Uncomment if you want to adjust the bandwidth for this thread
   #MYPID=$$	# Process ID for current script
   # Adjust niceness of CPU priority for the current process
   #renice 19 $MYPID
   echo "********************************************************"
   echo "Extracting subtitles w/ ccextractor for $FILENAME"
   echo "********************************************************"
   TEMPSRTFILENAME="/tmp/$(basename "$FILENAME" .ts).srt"
   ccextractor "$FILENAME" -o "$TEMPSRTFILENAME" 
   #ccextractor "$FILENAME" -o "$TEMPSRTFILENAME" || fatal "ccextractor has failed. Is it installed? There should be a symbolic link in /usr/local/bin"
   #ccextractor "$FILENAME" -svc all[UTF-8] -o "$TEMPSRTFILENAME" || fatal "ccextractor has failed. Is it installed? There should be a symbolic link in /usr/local/bin"

   # This section is less important since Plex now does transcoding as part of it's DVR process and this just mucks things up. I'm going to keep extracting subtitles for now
   #echo "********************************************************"
   #echo "Transcoding, Converting to H.264 w/Handbrake"
   #echo "********************************************************"
   #HandBrakeCLI -i "$FILENAME" -f mkv --srt-file "$TEMPSRTFILENAME" --srt-lang eng --srt-codeset utf-8 --aencoder copy -e qsv_h264 --x264-preset veryfast --x264-profile auto -q 16 --maxHeight 1080 --decomb bob -o "$TEMPFILENAME" || fatal "Handbreak has failed (Is it installed?)"
   #HandBrakeCLI -i "$FILENAME"  --srt-file "$TEMPSRTFILENAME" --srt-lang eng --srt-codeset utf-8 --preset  "H.264 MKV 1080p30"  -o "$TEMPFILENAME" || fatal "Handbreak has failed (Is it installed?)"
   #HandBrakeCLI -i "$FILENAME"  --preset  "H.264 MKV 1080p30"  -o "$TEMPFILENAME" || fatal "Handbreak has failed (Is it installed?)"

   echo "********************************************************"
   #echo "Cleanup / Copy $TEMPFILENAME to $FILENAME"
   echo "CLeanup"
   echo "********************************************************"

   #mv -vf "$TEMPFILENAME" "${FILENAME%.ts}.mkv"  || fatal "mv transcoded file failed"
   mv -vf "$TEMPSRTFILENAME" "${FILENAME%.ts}.eng.srt"
   #chmod -v 644 "${FILENAME%.ts}.mkv"
   chmod -v 644 "${FILENAME%.ts}.eng.srt"
   #rm -vf "$FILENAME"
   #rm -vf "$TEMPSRTFILENAME"
   echo "Done.  Congrats!"
else
   echo "PlexPostProc by nebhead"
   echo "Usage: $0 FileName"
fi
