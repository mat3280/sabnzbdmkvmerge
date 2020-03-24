#!/bin/bash
for file in "$1"
do
  subs=$(mkvmerge -I "$file" | grep 'SubStationAlpha\|HDMV\/PGS\|VobSub')
  audio=$(mkvmerge -I "$file" | grep 'sAtmos')
#  mkvmerge -I "$file" | grep 'SubRip' >> /media/scripts/logfile.log
    if [ ! -z "$subs" ] || [ ! -z "$audio" ];
    then
      echo $file >> /media/scripts/logfile.log
      # mkvmerge -I "$file" | grep 'SubStationAlpha\|HDMV\/PGS\|VobSub' >> /media/scripts/logfile.log
      # mkvmerge -I "$file" | grep 'sAtmos' >> /media/scripts/logfile.log
      #!/bin/sh
      echo $file

      mkvmerge -I "$file"
      audio=$(mkvmerge -I "$file" | sed -ne '/^Track ID [0-9]*: audio .* language:\(ger\|eng\|jpn\|und\).*/ { s/^[^0-9]*\([0-9]*\):.*/\1/;H }; $ { g;s/[^0-9]/,/g;s/^,//;p }')
      echo "1: found $audio to keep"
      subs=$(mkvmerge -I "$file" | sed -ne '/^Track ID [0-9]*: subtitles (SubRip\/SRT).* language:\(ger\|eng\).*/ { s/^[^0-9]*\([0-9]*\):.*/\1/;H }; $ { g;s/[^0-9]/,/g;s/^,//;p }')
      echo "2: found $subs to keep"

        if [ -z "$subs" ]
        then
          echo "3: Nothing to remove, will look for ASS & PGS Files"
          #Next two rows are redundant. can be deleted.
          audio=$(mkvmerge -I "$file" | sed -ne '/^Track ID [0-9]*: audio .* language:\(ger\|eng\|jpn\|und\).*/ { s/^[^0-9]*\([0-9]*\):.*/\1/;H }; $ { g;s/[^0-9]/,/g;s/^,//;p }')
          echo "4: found $audio to keep"
          ##
          subs=$(mkvmerge -I "$file" | sed -ne '/^Track ID [0-9]*: subtitles [(SubStationAlpha)|(ASS)|(HDMV/PGS)|(VobSub)].*/ { s/^[^0-9]*\([0-9]*\):.*/\1/;H }; $ { g;s/[^0-9]/,/g;s/^,//;p }')
          echo "5: found $subs subs."

          if [ -z "$subs" ]
          then
            ##Problem! languages which are not necessary won't be removed here.
            echo "6: Nothing found to remove. Will exit script now."
            exit
          else
            subs="-S";
            audio="-a $audio";
            mkvmerge $subs $audio -o "${file%.mkv}".edited.mkv "$file";
            mv "${file%.mkv}".edited.mkv "$file"
            echo "7: PGS/ASS/VobSub Subtitles found and removed!"
            # mv "$1" /media/Trash/;
          fi

        else
          echo "8: Found Subtitles. Will multiplex now"
          subs="-s $subs";
          audio="-a $audio";

          mkvmerge $subs $audio -o "${file%.mkv}".edited.mkv "$file";
          mv "${file%.mkv}".edited.mkv "$file"
          # mv "$1" /media/Trash/;



        fi

      fi
done
