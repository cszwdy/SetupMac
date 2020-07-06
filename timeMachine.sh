#!/bin/bash

MYDIR=`pwd`

# ---------- methods ----------
p_setup() {
	setup_homebrew() {
		if `command -v brew > /dev/null 2>&1`; then
			echo '✅ 已安装Homebrew'
		else
			echo '⏳ Homebrew安装中'
			/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
			if [[ $? -eq 0  ]]; then
				echo '✅ Homebrew安装成功'
			else
				echo '❌ Homebrew安装失败，请检查网络连接...'
				exit 127
			fi
		fi

		echo '⏳ Homebrew更新中（切换至USTC镜像,运行更加顺畅）'
		cd "$(brew --repo)"
		git remote set-url origin https://mirrors.ustc.edu.cn/brew.git

		cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
		git remote set-url origin https://mirrors.ustc.edu.cn/homebrew-core.git

		# cd "$(brew --repo)"/Library/Taps/homebrew/homebrew-cask
		# git remote set-url origin https://mirrors.ustc.edu.cn/homebrew-cask.git
#		brew update

		brew update > /dev/null
		
		if [[ $? -eq 0  ]]; then
			echo '✅ Homebrew更新成功'
		else
			echo '❌ Homebrew更新失败，请检查网络连接...'
			exit 127
		fi
	}


	setup_awk() {
		if ! `command -v awk > /dev/null`; then
			echo 未检测到AWK，请先安装AWK再执行本程序...
			exit 127
		fi
	}

	setup_cask() {
		if `command -v cask > /dev/null 2>&1`; then
			echo '✅ 已安装Cask'
		else
			echo '⏳ Cask安装中'
			brew install cask
			if [[ $? -eq 0  ]]; then
				echo '✅ Cask安装成功'
			else
				echo '⏳ Cask安装失败，请检查网络连接...'
				exit 127
			fi
		fi
	}
	
	setup_mas() {
		if `command -v mas > /dev/null 2>&1`; then
			echo '✅ 已安装Mas'
		else
			echo '⏳ Mas安装中'
			brew install mas
			if [[ $? -eq 0  ]]; then
				echo '✅ Mas安装成功'
			else
				echo '⏳ Mas安装失败，请检查网络连接...'
				exit 127
			fi
		fi
	}
	
	setup_gem() {
		if `command -v mas > /dev/null 2>&1`; then
			echo '✅ 已安装Gem'
		else
			echo '⏳ Gem安装中'
			brew install ruby
			if [[ $? -eq 0  ]]; then
				echo '✅ Gem安装成功'
			else
				echo '⏳ Gem安装失败，请检查网络连接...'
				exit 127
			fi
		fi
	}
	
	setup_xcoode_command_line_tools() {
		if `command -v xcode-select > /dev/null 2>&1`; then
			echo '✅ 已安装Command line tools'
		else
			echo '⏳ Command line tools安装中'
			xcode-select --install > /dev/null
			if [[ $? -eq 0  ]]; then
				echo '✅ Command line tools安装成功'
			else
				echo '⏳ Command line tools安装失败，请检查网络连接...'
				exit 127
			fi
		fi

	}
	
	setup_git() {
		name=$1
		if `command -v git > /dev/null 2>&1`; then
			echo '✅ 已安装Git'
		else
			echo '⏳ Git安装中'
			git --version > /dev/null
			if [[ $? -eq 0  ]]; then
				echo '✅ Git安装成功'
			else
				echo '⏳ Git安装失败，请检查网络连接...'
				exit 127
			fi
		fi
	}
	
	setup_node() {
			name=$1
			if `command -v node > /dev/null 2>&1`; then
				echo '✅ 已安装Node'
			else
				echo '⏳ Node安装中'
				git --version > /dev/null
				if [[ $? -eq 0  ]]; then
					echo '✅ Node安装成功'
				else
					echo '⏳ Node安装失败，请检查网络连接...'
					exit 127
				fi
			fi
			
			echo '⏳ Node更新中'
			brew upgrade node > /dev/null
			
			if [[ $? -eq 0  ]]; then
				echo '✅ Node更新成功'
			else
				echo '❌ Node更新失败，请检查网络连接...'
#				exit 127
			fi
		}
	
	setup_xcoode_command_line_tools
	setup_git
	setup_homebrew
	setup_cask
	setup_gem
	setup_awk
	setup_mas
	setup_node
	echo
}


p_install_sofeware() {
	show() {
		cd $MYDIR
		chmod a+x Sofeware.csv
		awk -F ',' 'NR > 1 {printf("%-4s %-22s %-6s  %-12s  %-5s\n", NR-1, $1, $2, $3, $4)}' Sofeware.csv
	}
	
	install() {
		check_installation() {
			read -d "\r" name channel masID category <<< "${1//','/$'\n'}"

			if [[ $channel == "Brew" ]]; then
				brew list -l | grep $name > /dev/null
			elif [[ $channel == "Cask" ]]; then
				brew cask list -1 | grep $name > /dev/null
			elif [[ $channel == "Mas" ]]; then
				mas list | grep $masID > /dev/null
			elif [[ $channel == "Gem" ]]; then
				mas list | grep $name > /dev/null
			else
				return 1
			fi

			if [[ $? -eq 0 ]]; then
				echo "${name}已经安装过，继续下一个..."
				return 0
			fi
			return 1
		}
		
		installation() {
			read -d "\r" name channel masID category <<< "${1//','/$'\n'}"
			if [[ $channel == "Brew" ]]; then
				echo '⏳ 开始安装' $name '...'
				brew install $name 
			elif [[ $channel == "Cask" ]]; then
				echo '⏳ 开始安装' $name '...'
				brew cask install $name 
			elif [[ $channel == "Mas" ]]; then
				echo '⏳ 开始安装' $name '...'
				mas install $masID
			elif [[ $channel == "Gem" ]]; then
				echo '⏳ 开始安装' $name '...'
				gem install $name 
			else
				return 1
			fi
		}
		
			
		read  -p "输入待安装的软件编号（回车安装全部，空格分隔多个编号）：" ans
		echo
		IFS=$'\n'
		read -d "" -ra arr <<< "${ans//' '/$'\n'}" # 本脚本中最喜欢的一句代码了
		
		# 回车安装全部
		if [[ "${#arr[@]}" -eq 0 ]]; then
			lines=`wc -l Sofeware.csv | awk '{printf $1}'`
#			count=`expr $lines \* 3`
			for((i=1; i<$lines+1; i++)); do
				arr[$i]=$i
			done
		fi
		
		for l in ${arr[*]}; do
			line=`awk -F ',' -v a=$l 'NR==a+1 {printf"%s,%s,%s,%s", $1, $2, $3, $4}' Sofeware.csv`
#			echo $line
			check_installation $line
			
			if [[ $? -eq 0 ]]; then
				echo
			else
				installation $line
				if [[ $? -eq 0 ]]; then
					echo "✅ 安装成功 " $line
				else
					echo "❌ 安装失败" ${l} ${line}
					echo
				fi
			fi
#			if [ $app -eq $app 2>/dev/null ]; then
#				:
#			else
#				continue
#			fi
#
#			locate $app
#			name=`get_package_name "$type"".txt" $row_number $column_number`
#			[ -z "$name" ] && continue
#			install $name
		done
		echo "🟢 全部安装完毕"
		
	}
	
	show
	echo
	install
}


# ---------- shell run ----------

# 1 - introduction
cat << EOF
#######################################################################
# 当前脚本用于在运行OS X的电脑上安装应用程序
# 原理为：利用homebrew作为OS X的包管理器
#         brew install 安装命令行程序
#         brew cask install 安装GUI程序
#         Happy coding ~ Happy life.
#
# Author: jsycdut <jsycdut@gmail.com>
# Github: https://github.com/jsycdut/mac-setup
#
# 祝使用愉快，有问题的话可以去GitHub提issue
#
# 注意事项
#
# 1. OS X尽量保持较新版本，否则可能满足不了Homebrew的依赖要求
# 2. 中途若遇见安装非常慢的情况，可用Ctrl+C打断，直接进行下一项的安装
# ┌────────────────┐
# │                │
# │     Setup      │
# │                │
# └────────────────┘
#   ┌─────────────────────┐
#   │ code command lines  │
#   └─────────────────────┘
#   ┌─────────────────────┐
#   │         git         │
#   └─────────────────────┘
#   ┌─────────────────────┐
#   │      homebrew       │
#   └─────────────────────┘
#   ┌─────────────────────┐
#   │         gem         │
#   └─────────────────────┘
#   ┌─────────────────────┐
#   │         awk         │
#   └─────────────────────┘
#   ┌─────────────────────┐
#   │         mas         │
#   └─────────────────────┘
#   ┌─────────────────────┐
#   │        node         │
#   └─────────────────────┘
# ┌────────────────┐
# │                │
# │    Install     │
# │                │
# └────────────────┘
#   ┌─────────────────────┐
#   │    Sofeware.csv     │
#   └─────────────────────┘
#   ┌─────────────────────┐
#   │   select install    │
#   └─────────────────────┘
#   ┌─────────────────────┐
#   │   check installed   │
#   └─────────────────────┘
#   ┌─────────────────────┐
#   │    installation     │
#   └─────────────────────┘
# ┌────────────────┐
# │                │
# │     Finish     │
# │                │
# └────────────────┘
#
# Created with Monodraw
#######################################################################
EOF

export http_proxy=http://127.0.0.1:1087;export https_proxy=http://127.0.0.1:1087;

# 2 - setup
p_setup


# 3 - install sofewares
p_install_sofeware

