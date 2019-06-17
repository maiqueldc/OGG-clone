./ggsci << EOF > gg_config.out
info all
EOF

#CHECK EXTRACT CONFIG
cat gg_config.out|egrep "EXTRACT"|awk {' print $3 '}|while read line;
do
echo "--EXTRACT "$line;
./ggsci << EOF > $line.out
        info $line detail
EOF
        TRAILFILE_TEMP=`cat $line.out|grep "Log Read Checkpoint"|awk {' print $5 '}`
        STRING_FIND="dirdat"
        cutpos=`awk -v a="$TRAILFILE_TEMP" -v b="$STRING_FIND" 'BEGIN{print index(a,b)}'`
        TRAILFILE=`echo $TRAILFILE_TEMP|cut -c $cutpos-11`
        echo "add extract $line, exttrailsource ./$TRAILFILE, begin now"
        cat $line.out|grep RMTTRAIL|awk {' print $1 '}|while read rmttrail; do
                echo "add rmttrail $rmttrail, extract $line"
        done
rm $line.out
done

#CHECK REPLICAT CONFIG
cat gg_config.out|egrep "REPLICAT"|awk {' print $3 '}|while read line;
do
echo "REPLICAT "$line;
./ggsci << EOF > $line.out
        info $line detail
EOF
        CHECKPOINT=`cat $line.out|grep "Checkpoint table"|awk {' print $3 '}`
        TRAILFILE=`cat $line.out|grep "Log Read Checkpoint"|awk {' print $5 '}`
        echo "--REPLICAT"
        echo "add replicat "$line", exttrail "$TRAILFILE", checkpoint table "$CHECKPOINT
rm $line.out
done
