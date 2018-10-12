for f in UDO-Tester/json/*.json
# do echo mv "$f" "${f/_*_/_}";
# do echo python ../CosmoToCsd.py "$f" "${f}_.csd"
do python CosmoToCsd.py "$f" "${f}_.csd"
done
