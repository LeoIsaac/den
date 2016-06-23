#!/bin/bash
my_dirname=$(dirname $0)
cd $my_dirname

ESC="\033["
COLOR_NAME="${ESC}0;36m"
COLOR_DONE="${ESC}1;32m"
COLOR_TITLE="${ESC}1;35m"
COLOR_LRED="${ESC}0;35m"
COLOR_RED="${ESC}1;31m"
COLOR_BLUE="${ESC}1;34m"
COLOR_OFF="\033[m"
DONE="${COLOR_DONE}[Done]${COLOR_OFF} "
WARNING="${COLOR_LRED}Warning${COLOR_OFF}: "
ERROR="${COLOR_RED}Error${COLOR_OFF}: "
QUESTION="${COLOR_BLUE}Q${COLOR_OFF}. "

# black
z="${ESC}40m　${COLOR_OFF}"
# red
r="${ESC}41m　${COLOR_OFF}"
# green
g="${ESC}42m　${COLOR_OFF}"
# yellow
y="${ESC}43m　${COLOR_OFF}"
# blue
b="${ESC}44m　${COLOR_OFF}"
# pink
p="${ESC}45m　${COLOR_OFF}"
# light_blue
l="${ESC}46m　${COLOR_OFF}"
# white
w="${ESC}47m　${COLOR_OFF}"

echo -e "
  //////////////////////////////////
  //   電口調のppchkall ver.5.01  //
  //       2015/10/16 16:30       //
  //      Made by ${COLOR_NAME}@_leo_isaac${COLOR_OFF}     //
  //////////////////////////////////

  *送信するファイルにコメントが含まれていなかったら、自動でコメントを付加する。test.shを参照すること。
"

function helper {
    IFS_backup=$IFS
    IFS=$''
    source ./dot.txt
    rand=$(( RANDOM % 4 ))
    case $rand in
	0)
	    echo -e $pika;;
	1)
            echo -e $marill;;
	2)
	    echo -e $gardevoir;;
	3)
	    echo -e $mario;;
    esac
    IFS=$IFS_backup
    
    echo -e "    ${COLOR_TITLE}About${COLOR_OFF}
「ppchkallでファイルを一気に指定したい...」、誰でも人生で一度はそう考えると思います。
そこでシェルスクリプトを使ってppchkallを一気に実行するやつを作ってみました。
第六駆逐隊、特に電が好きなので、電口調で指示等してくれますが、お好きな口調に書き換えることもできます。そこらへんはご自由にどうぞ。

    ${COLOR_TITLE}How to use${COLOR_OFF}
[./den.sh -help]のように./den.shに続けてオプションを入力することで各オプションを実行します。また、[./den.sh a b c]のように./den.shに続けて複数のファイル名を入力することで一気にチェックに通します。オプションについては以下を参照してください。なお、[./]を付け忘れると動作しませんコマンドに紐付けない限りは。

    ${COLOR_TITLE}Option${COLOR_OFF}
./den.sh に続けてオプションを指定できます。
-all\t\t今いるディレクトリ内にある、課題っぽい全てのファイルをppchkallに通すのです。
-co\t\t[${COLOR_RED}現在開発中${COLOR_OFF}] 今いるディレクトリ内にある.cファイルを全部コンパイルするのです。
-cp\t\tローカルとサーバー間でデータのやりとりをするのです。
-h/-help\t今ご覧になってるヘルプを表示するのです。
-isaac\t\t製作者Isaacの最新のツイート10件を取得するのです。
-rf\t\t指定したディレクトリの中の一時ファイルを削除するのです。
-rm\t\t指定したディレクトリの中身を全て削除するのです。
-tl\t\tタイムラインを表示するのです。
-tw\t\t授業中にバレないようにツイートするのです。
"
}


function tweet {
    if [ $# == 0 ]
    then
	echo -e "${WARNING}-twの後にツイート内容を入力してくださいなのです。\n"
	exit
    fi
    echo "「$*」と呟くのです。"
    echo -en "\n${QUESTION}よろしいのです?(y/n) > "
    read ans
    case $ans in
        *y* | *Y*)
	    php ./denden/twitter.php tweet $*
	    if [ $? == 0 ]
	    then
		echo -e "${DONE}呟きが完了したのです!!"
	    else
		echo -e "${ERROR}正常に呟けなかったのです..."
	    fi;;
	*)
	    echo "呟くのをやめたのです。";;
    esac
}


function isaac {
    php denden/twitter.php isaac
    if [ $? != 0 ]
    then
	echo -e "${ERROR}よく分からないけど、エラーなのです..."
    fi
}


function scper {
    echo -en "${QUESTION}コピーの方向を指定してほしいのです。(to [local] / [server]) > "
    read ans
    case $ans in
	"local" | "server")
	    echo -en "\n${QUESTION}コピー元を指定してほしいのです。 > "
	    read copy_from
	    echo -en "\n${QUESTION}コピー先を指定してほしいのです。 > "
	    read copy_to
	    case $ans in
		"local")
		    scp b1015078@maccalc01.fun.ac.jp:${copy_from} ${copy_to};;
		"server")
		    scp ${copy_from} b1015078@maccalc01.fun.ac.jp:${copy_to};;
	    esac
	    if [ $? == 0 ]
	    then
		echo -e "${DONE}コピーに成功したのです!!"
	    else
		echo -e "${ERROR}コピーに失敗したのです..."
	    fi;;
	*)
	    echo -e "コピーしないのです...";;
    esac
}


function refresh {
    echo -en "${QUESTION}ディレクトリを指定してほしいのです。 > "
    read dir
    cd $dir
    echo `pwd`
    echo `ls`
    msg=`ls ./`
    ary=(`echo $msg`)
    for i in `seq 1 ${#ary[@]}`
    do
	file=${ary[$i-1]}
	case $file in
	    *[~#]* | *0* | *exit_intime*)
		echo -en "\n${QUESTION}${file}を削除するのです。よろしいのですか??(y/n) > "
		read ans
		case $ans in
		    *y* | *Y*)
		     	rm $file
			if [ $? == 0 ]
			then
			    echo -e "${DONE}${file}を削除したのです。"
			else
			    echo -e "${ERROR}${file}の削除に失敗したのです..."
			fi;;
		    *)
			echo -e "${file}は削除しないのです。";;
		esac;;
	    *)
	    ;;
	esac
    done
}


function remover {
    echo -en "${QUESTION}中身を削除するディレクトリを入力してくださいなのです > "
    read num
    url=/FUN/Work/pp2015/$num/d/b1015078/*
    if [ ! -d ${url%/*} ]
    then
	echo -e "${ERROR}${url%/*} が存在しないのです...\n"
	exit
    fi
    echo "${url%/*} の中身を全部削除するのです。"
    echo -en "\n${QUESTION}本当に中身を全部削除してよろしいのです?(y/n) > "
    read ans
    case $ans in
        *y* | *Y*)
	    msg=`rm -r $url`
	    if [ $? == 0 ]
	    then
		echo -e "${DONE}削除に成功したのです。"
	    else
		echo -e "${ERROR}権限が無いか、もしくはディレクトリが存在しないためにエラーなのです..."
	    fi;;
	*)
	    echo "削除しないのです。";;
    esac
}


function all {
    echo -e "${dir}内の課題っぽいファイルをチェックしていくのです。\n"
    msg=`ls ./`
    if [ $? == 0 ]
    then
	ary=(`echo $msg`)
	for i in `seq 1 ${#ary[@]}`
	do
	    file=${ary[$i-1]}
	    case $file in
		*[~#.0]* | *0* | *exit_intime*)
		    ;;
		*)
		    echo "----- $file -----"
		    echo "${file}をチェックするのです。"
		    ppchkall $file
		    msg=`ppchkall $file`
		    if [ $? == 0 ]
		    then
			case $msg in
			    *uccess*)
				echo -e "${DONE}成功なのです!!\n"
				success=$((success + 1));;
			    *)
				echo -e "${WARNING}失敗なのです...\n"
				error=$((error + 1));;
			esac
		    else
			echo -e "${WARNING}多分、学内LAN接続されていないのです...\n"
			error=$((error + 1))
		    fi;;
	    esac
	done
    else
        error=$((error + 1))
    fi
}


function sender {
    echo -en "\n${QUESTION}何回目の授業なのです? > "
    read num
    url=/FUN/Work/pp2015/${num}/d/b1015078/
    if [ ! -d $url ]
    then
	echo $url
	echo -en "${ERROR}そんなディレクトリは存在しないのです...\n\n"
	exit
    fi
    echo "$url にコピーするのです。"
    echo -en "\n${QUESTION}よろしいのです?(y/n) > "
    read ans
    case $ans in
	*y* | *Y*)
	    if [ $option == "-all" ]
	    then
		msg=`ls ./`
		ary=(`echo $msg`)
		for i in `seq 1 ${#ary[@]}`
		do
		    file=${ary[$i-1]}
		    case $file in
			*[~#]* | *.* | *0* | *exit_intime*)
			    ;;
			*)
			    echo "----- $file -----"
			    msg=`cat ${file}.c`
			    case $msg in
				*xercise*)
				    echo "コメントは既に入力されているのです。";;
				*)
				    echo -e "${WARNING}${file}.cにコメントが入力されていないのです..."
				    echo -en "\n${QUESTION}コメントを追加するのです??(y/n) > "
				    read ans
				    case $ans in
					*y* | *Y*)
					    echo -en "\n${QUESTION}何回目の授業でしたっけ...? > "
					    read class
					    echo -en "\n${QUESTION}何個目のファイルなのです?? > "
					    read num
coment=`cat <<EOF | ed ${file}.c
0a
/*
 * Exercise ${class}-${num}, ${file}.c
 * b1015078 Reo Sato
 */

.
wq
EOF`
					    echo -e "${DONE}${class}-${num}としてコメントを追加したのです!!";;
					*)
					    echo "コメントを追加しないのです。";;
				    esac;;
			    esac
			    cp $file $url
			    type=".c"
			    file_c=$file$type
			    cp $file_c $url
			    echo "${file}と${file_c}をコピーするのです。"
			    if [ $? == 0 ]
			    then
				echo -e "${DONE}成功なのです!!"
			    else
				echo -e "${ERROR}権限が無いか、もしくはディレクトリが存在しないのです..."
			    fi;;
		    esac
		done
	    else
		for file in $*
		do
		    echo "${file}をコピーするのです。"
		    cp $file $url
		    type=".c"
		    file_c=$file$type
		    cp $file_c $url
		    if [ $? == 0 ]
		    then
			echo -e "${DONE}$file_c と $file のコピーに成功したのです!!"
		    else
			echo -e "${ERROR}$file_c と $file のコピーに失敗してしまったのです..."
		    fi
		done
	    fi;;
	*)
	    echo "送信しないのです。";;
    esac
}


# main
if [ "$#" == 0 ]
then
    echo -e "${WARNING}ファイル名、またはオプションを指定してほしいのです!!
詳しくはオプションに-h、または-helpを指定してください。
"
elif [ $1 == "-h" ]
then
    helper
elif [ $1 == "-help" ]
then
    helper
elif [ $1 == "-tw" ]
then
    while [ "$1" != "" ]
    do
	if [ $1 != "-tw" ]
	then
	    murmur="$murmur $1"
	fi
	shift
    done
    tweet $murmur
elif [ $1 == "-tl" ]
then
    echo "なぜか時刻がUTCで表示されるのです..."
    php ./denden/twitter.php timeline
    if [ $? != 0 ]
    then
	echo -e "${ERROR}何かは分からないけどエラーなのです..."
    fi
elif [ $1 == "-isaac" ]
then
    isaac
elif [ $1 == "-cp" ]
then
    scper
elif [ $1 == "-rf" ]
then
    refresh
elif [ $1 == "-rm" ]
then
    url=/FUN/Work/pp2015/
    if [ -d $url ]
    then
	remover
    else
	echo -e "${ERROR}学内LANに繋がっていないのです..."
    fi
else
    echo -en "${QUESTION}ディレクトリ名を入力してほしいのです > "
    read dir
    if [ ! -e $dir ]
    then
	echo -e "${ERROR}そんなディレクトリは存在しないのです...\n"
	exit
    fi
    cd $dir
    success=0
    error=0
    if [ $1 == "-all" ]
    then
	option="-all"
	all
    else
	for name in $*
	do
	    echo "----- $name -----"
	    echo -e "${COLOR_RED}削除予定文${COLOR_OFF}: ${name}を指定しています"
	    result=`ppchkall $name`
	    case $result in
		*uccess*)
		    echo -e "${DONE}成功なのです!!"
				        success=$((success + 1));;
		*)
		    if [ $? == 0 ]
		    then
			echo -e "${WARNING}失敗なのです..."
		    else
			echo -e "${ERROR}ファイル名が違うか、もしくは学内LANに接続されていないのです。"
		    fi
    error=$((error + 1));;
	    esac
	done
    fi
    echo "===================="
    if [ $error = "0" ]
    then
        echo "$success 個全て成功なのです!!"
	echo -en "\n${QUESTION}送信するのです?(y/n) > "
	read ans
	case $ans in
	    *y* | *Y*)
		sender;;
	    *)
		echo "送信しないのです。";;
	esac
	echo -e "\nお疲れ様なのです。"
    elif [ $success = "0" ]
    then
        echo "$error 個全て失敗しちゃったのです..."
    else
        echo "$success 個は成功、$error 個は失敗なのです。"
    fi
fi
echo
