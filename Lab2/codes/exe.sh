make
./CPU.out
echo "==============Diff Part==========================="

diff -w ./output.txt ../testdata/output_2.txt
