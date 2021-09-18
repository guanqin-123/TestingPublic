#!/bin/

# git clone https://github.com/SVF-tools/SVF-Teaching-Solutions.git
# git clone https://github.com/SVF-tools/SVF.git
# cd SVF && ./build.sh
# cd ..

res_folder=$GITHUB_WORKSPACE/results
# echo results folder: $res_folder
sol_folder=$GITHUB_WORKSPACE/SVF-Teaching-Solutions
# echo SVF-Teaching-Solution folder: $sol_folder

ass1_folder=$sol_folder/Assignment-1
ass2_folder=$sol_folder/Assignment-2
ass3_folder=$sol_folder/Assignment-3
ass4_folder=$sol_folder/Assignment-4

cd $sol_folder

for i in $(ls $GITHUB_WORKSPACE/Assignment-1-Submissions/*.cpp)
do
    echo Start marking $i ...
    rm -rf $ass1_folder/*.cpp
    rm -rf $ass1_folder/assign-1-*
    cp $i $ass1_folder/Assignment-1.cpp
    make >& $res_folder/${i##*/}.log.txt
    wait
    echo Marking Assignment-1 >> $res_folder/${i##*/}.txt ;  
    $ass1_folder/assign-1 2>> $res_folder/${i##*/}.txt 1> /dev/null
done

mv $ass2_folder/assign-2 $ass2_folder/test-exes

for i in $(ls $GITHUB_WORKSPACE/Assignment-2-Submissions/*.cpp)
do
    echo Start marking $i ...
    rm -rf $ass2_folder/*.cpp
    rm -rf $ass2_folder/assign-2-*
    cp $i $ass2_folder/Assignment-2.cpp
    make >& $res_folder/${i##*/}.log.txt
    wait
    totalCases=0
    passedCases=0
    for n in $(ls $ass2_folder/testcase/bc/*.ll)
    do   
        ((totalCases+=1))
        echo Testing ${n##*/} >> $res_folder/${i##*/}.sol.txt ;  
        $ass2_folder/test-exes/assign-2 $n 2> solution 1> /dev/null
        cat solution >> $res_folder/${i##*/}.sol.txt
        echo Testing ${n##*/} >> $res_folder/${i##*/}.sub.txt ;  
        $ass2_folder/assign-2  $n 2> submission 1> /dev/null
        cat submission >> $res_folder/${i##*/}.sub.txt
        diff solution submission &&  ((passedCases+=1))
    done 
    diff -y $res_folder/${i##*/}.sub.txt $res_folder/${i##*/}.sol.txt > $res_folder/${i##*/}.diff.txt
    echo "" >> $res_folder/${i##*/}.diff.txt
    echo Total passed cases: $passedCases / $totalCases >> $res_folder/${i##*/}.diff.txt
done

#gdb -ex=r -ex bt --args $ass2_folder/assign-2 $n |& tee backtrace.log.txt

for i in $(ls $GITHUB_WORKSPACE/Assignment-3-Submissions/*.cpp)
do
    echo Start marking $i ...
    rm -rf $ass3_folder/*.cpp
    rm -rf $ass3_folder/assign-3-*
    cp $i $ass3_folder/Assignment-3.cpp
    echo ${i##*/}
    make >& $res_folder/${i##*/}.log.txt
    wait
    for((n=1;n<=3;n++));  
    do   
        echo Testing ${n##*/} >> $res_folder/${i##*/}.txt ;  
        $ass2_folder/assign-3-$n >> $res_folder/${i##*/}.txt
        echo $res_folder/${i##*/}.txt
    done
done

for i in $(ls $GITHUB_WORKSPACE/Assignment-4-Submissions/*.cpp)
do
     echo Start marking $i ...
     rm -rf $ass4_folder/*.cpp
     rm -rf $ass4_folder/assign-4-*
     cp $i $ass4_folder/Assignment-4.cpp
     echo ${i##*/}
     make >& $res_folder/${i##*/}.log.txt
     wait
     for((n=1;n<=2;n++));  
     do   
         echo Testing ${n##*/} >> $res_folder/${i##*/}.txt ;  
         $ass4_folder/assign-4-$n >> $res_folder/${i##*/}.txt
         echo $res_folder/${i##*/}.txt
     done 
done
