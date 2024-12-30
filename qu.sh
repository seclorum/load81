application="load81"
date=$(printf %x $(date +%s))
uuid=$(/usr/bin/uuidgen)
/usr/bin/xattr -w com.apple.quarantine "0002;${date};${application};${uuid}" load81
