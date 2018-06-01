##shell的特殊变量

```shell
#!/bin/bash
#echo：打印输出---print
echo $0    # 当前脚本的文件名（间接运行时还包括绝对路径）。
echo $n    # 传递给脚本或函数的参数。n 是一个数字，表示第几个参数。例如，第一个参数是 $1 。
echo $#    # 传递给脚本或函数的参数个数。
echo $*    # 传递给脚本或函数的所有参数。
echo $@    # 传递给脚本或函数的所有参数。被双引号 (" ") 包含时，与 $* 不同，下面将会讲到。
echo $?    # 上个命令的退出状态，或函数的返回值。
echo $$    # 当前 Shell 进程 ID。对于 Shell 脚本，就是这些脚本所在的进程 ID。
echo $_    # 上一个命令的最后一个参数
echo $!    # 后台运行的最后一个进程的 ID 号

```

事例：

```
#!/bin/bash
echo "file name is '$0'"
echo "\$*=" $*

echo "\$@=" $@

echo "print each param from \$*"
for var in $*
do
    echo "$var"
done

echo "print each param from \$@"
for var in $@
do
    echo "$var"
done

echo "从 \"\$*\" 获取并打印每一个参数"
for var in "$*"
do
    echo "$var"
done

echo "从 \"\$@\" 获取并打印每一个参数"
for var in "$@"
do
    echo "$var"
done

```

##获取输入参数`getopts`

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