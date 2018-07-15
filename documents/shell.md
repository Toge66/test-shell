# Shell语法

## `#`
用来注释

## #!
脚本的第一行。
特殊的表示符，其后面跟的是此解释此脚本的shell的路径

`#!/bin/sh`
`#!/bin/bash`
> 写js脚本使用`#!/usr/bin/env node`
## 

##特殊符号
单引号（’）、双引号（”）、反引号（`）、美元符号（$）和反斜杠（\）

+ 反引号（\`）：在shell中起到命令替换的作用。能够将一个`命令`的输出插在对应的位置，反引号内的内容如果不是命令会报错
	
	```
	echo "now is `date`"
	输出：now is 2018年 6月 6日 星期三 10时12分08秒 CST
	```
	> `$()`和反引号的作用相同：[建议使用`$()`](https://blog.csdn.net/apache0554/article/details/47055827)
+ 美元符号（$）：对shell变量的引用
	
	```
	#!/bin/sh
	PATH=`pwd`
	echo $PATH
	```
	>引用变量的时候`$var`与`${var}`并没有啥不一样，用`${}`会比较精确的界定变量名称的范围
	>> `${}`还有一些高级的用法
	>> 
	```
	#!/bin/sh
	file='/dir1/dir2/dir3/my.file.txt'
	#：拿掉第一条/及其左边的字符串：dir1/dir2/dir3/my.file.txt
	${file#*/}
	#：拿掉最后一条/及其左边的字符串：my.file.txt
	${file##*/}
	#：拿掉第一个. 及其左边的字符串：file.txt
	${file#*.}
	#：拿掉最后一个. 及其左边的字符串：txt
	${file##*.}
	#：拿掉最后条/及其右边的字符串：/dir1/dir2/dir3
	${file%/*}
	#：拿掉第一条/及其右边的字符串：(空值)
	${file%%/*}
	#：拿掉最后一个. 及其右边的字符串：/dir1/dir2/dir3/my.file
	${file%.*}
	#：拿掉第一个. 及其右边的字符串：/dir1/dir2/dir3/my
	${file%%.*}
	```
+ 单引号（’）： 将单引号内的内容原样输出，或者描述为单引号里面看到的是什么就会输出什么，被单引号括起的内容不管是常量还是变量者不会发生替换
	
	```
	#!/bin/sh
	PATH=`pwd`
	echo 'position : $PATH'
	
	执行后输出：position : $PATH
	```
+ 双引号（”）：如果内容中有命令、变量等，会先把变量、命令解析出结果，然后在输出最终内容来，被双引号括起的内容常量还是常量，变量则会发生替换，替换成变量内容
	
	```
	#!/bin/sh
	PATH=`pwd`
	echo 'position : $PATH'
	
	执行后输出：position : /Users/toge/Desktop/Study/note/shell
	```
+ 反斜杠（\）：取消特殊字符的特殊含义

##变量
+ 变量声明、使用
	
	[`export`] `变量名`=`值` 等号左右两边不能由空格
	>变量名是区分大小写的，按照惯例，环境变量和内部shell变量都大写。所有其他变量名应为小写。这个约定避免了意外超越环境和内部变量。
	
	>遵循这个约定，你可以放心，你不需要知道UNIX工具或shell使用的每个环境变量，以避免覆盖它们。如果它是你的变量，小写它。如果你导出它，大写它
	
	
	```
	#/bin/sh
	a=3
	echo $a
	echo ${a}
	```

+ 环境变量
	- 环境变量可以从父进程传给子进程，因此Shell进程的环境变量可以从当前Shell进程传给fork出来的子进程。用printenv命令可以显示当前Shell进程的环境变量。
+ 本地变量
	- 只存在于当前Shell进程，用set命令可以显示当前Shell进程中定义的所有变量（包括本地变量和环境变量）和函数。
+ 特殊变量（脚本中获取参数）

	```shell
	#!/bin/bash
	#echo：打印输出---print
	echo $0    # 当前脚本的文件名（间接运行时还包括绝对路径）。
	echo $n    # 传递给脚本或函数的参数。n 是一个数字，表示第几个参数。例如，第一个参数是 $1 。
	echo $#    # 传递给脚本或函数的参数个数。
	echo $*    # 传递给脚本或函数的所有参数。
	echo $@    # 传递给脚本或函数的所有参数。被双引号 (" ") 包含时，与 $* 不同，下面会有例子。
	echo $?    # 上个命令的退出状态，或函数的返回值。
	echo $$    # 当前 Shell 进程 ID。对于 Shell 脚本，就是这些脚本所在的进程 ID。
	echo $_    # 上一个命令的最后一个参数
	echo $!    # 后台运行的最后一个进程的 ID 号
	
	```

	```
	#!/bin/bash
	echo "获取文件名-\$0'：" $0
	echo "第一个参数-\$1'：" $1
	echo "参数个数-\$#'：" $#
	echo "当前Shell进程ID-\$$'：" $$
	echo "所有参数-\$*" $*
	echo "所有参数-\$@" $@
	
	echo "=======\$*和\$@=========="
	echo "----\$*----"
	for var in $*
	do
	    echo "$var"
	done
	
	echo "----\$@----"
	for var in $@
	do
	    echo "$var"
	done
	
	echo "=======\$*和\$@带引号=========="
	echo "----\$*----"
	for var in "$*"
	do
	    echo "$var"
	done
	
	echo "----\$@----"
	for var in "$@"
	do
	    echo "$var"
	done
	
	```

+ 获取输入参数的值`getopts`

	```
	while getopts "s:sourcepath" arg
	do
	    case $arg in
	        s)
	            echo "source path:$OPTARG"
	            ;;
	        *)
	            echo "unknown option $arg"
	            ;;
	    esac
	done
```

## 逻辑表达式
+ `test` 表达式

	```
	test 1 = 1 && echo '==ok=='
	test -d /etc/ && echo '==ok=='
	test 1 -eq 1 && echo '==ok=='
	```
	> 空格不能少
+ `[ 表达式 ]`
	
	```
	[ 2\>1 ] && echo '==ok=='
	[ 3 -lt 4 ] && echo '==ok=='
	```
	> 在`[]`表达式中需要对`>`,`<`转译
+ `[[ 表达式 ]]`
	```
	[[ 2 > 1 ]] && echo '==ok=='
	```
	>对`[]`的扩充，支持`>`,`<`不需要转译
	
## 语句
+ 条件语句
	####if/else
	
	```
	#! /bin/sh
	if condition
	then 
		 do something
	elif condition
	then 
		do something
	elif condition
	then 
		do something
	else
		do something
	fi
	```
	
	事例：
	
	```
	#! /bin/sh
	a=1
	if [ $1=$a ]
	then
		echo "you input 1"
	elif [ $1=2 ]
	then
		echo "you input 2"
	else
		#do nothing
		echo " you input $1"
	fi
	```
	> 注意, `[ ]` 两边一定要加空格,`test`命令的另一种形式`/bin/[`
	> >[查看其它括号不同使用方法](http://blog.csdn.net/tttyd/article/details/11742241).
	
	```
	#! /bin/sh
	if test "2>3"
	then
		...
	fi
	```
	
	```
	#! /bin/sh
	if [ "2>3" ]
	then 
		...
	fi
	```
	
	####case
	```
	#! /bin/sh
	case expression in
		pattern1)
			do something... ;;
		pattern2)
			do something... ;;
		pattern2)
			do something... ;;
		...
	esac
	```
	>NOTE:
	>> * `;;`相当于其它语言中的break
	>> * 每个pattern之后记得加`)`
	>> * 最后记得加`esac`
	
	事例：
	
	```
	#! /bin/sh
	input=$1
	case $input in
	        1 | 0)
	        str="一or零";;
	        2)
	        str="二";;
	        3)
	        str="三";;
	        *)
	        str=$input;;
	esac
	echo "---$str"
	``` 
+ 循环语句
	>shell中也支持`break`跳出循环, `continue`跳出本次循环.
	
	####for
	
	```
	#! /bin/sh
	for (( i=0; i<10; i++)); do
		touch test_$i.txt
	done
	```
	```
	#! /bin/sh
	for name [in list]
	do
		...
	done
	```
	其中,[]括起来的 `in list`, 为可选部分, 如果省略`in list`则默认为`in "$@"`, 即你执行此命令时传入的`参数列表`.
	看个例子:
	
	```
	#! /bin/sh
	for file in *.txt
	do
		open $file
	done
	```
	
	####while
	
	```
	#! /bin/sh
	i=0
	while ((i<5));
	do
		((i++))
		echo "i=$i"
	done
	```
	
	####until
	
	```
	#! /bin/sh
	i=5
	until ((i==0))
	do
		((i--))
		echo "i=$i"
	done
	```

























