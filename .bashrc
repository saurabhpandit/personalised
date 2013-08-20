# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

function setAllProxies()
{
	if [ -e ~/.proxypid ]
	then
  		echo "ssh tunnel exists"
	else
		ssh -N -n -f -q -l pands -L 3128:121.200.231.211:8080 172.16.64.62
	    sudo netstat -tpln | grep 127\.0\.0\.1:3128 | awk '{print $7}' | sed 's#/.*##' > ~/.proxypid
	fi

	export http_proxy=127.0.0.1:3128
	export ftp_proxy=127.0.0.1:3128
	export https_proxy=127.0.0.1:3128

	export HTTP_PROXY=127.0.0.1:3128
	export FTP_PROXY=127.0.0.1:3128
	export HTTPS_PROXY=127.0.0.1:3128
}

export ORACLE_BASE=/opt/oracle
export ORACLE_HOME=${ORACLE_BASE}/instantclient_11_2

# User specific aliases and functions

function vm6()
{
	ssh vm6
}

function unsetAllProxies()
{
	cat ~/.proxypid | xargs kill
	rm -f ~/.proxypid
	unset http_proxy
	unset ftp_proxy
	unset https_proxy
	
	unset HTTP_PROXY
	unset FTP_PROXY
	unset HTTPS_PROXY
}

function startDropbox()
{
	env http_proxy=http://127.0.0.1:3128 /home/pands/.dropbox-dist/dropboxd &
}

function activatePylon()
{
	source ~/pyvirtual/pylons/bin/activate
}

function activateVenv()
{
	source ~/workspace/venv/bin/activate
}

function mountportaldev()
{
	sshfs root@portaldev.nn.local:/root/workspace /home/pands/workspace/workspace@portaldev
}

function unmountportaldev()
{
	sudo umount -v /home/pands/workspace/workspace@portaldev
}

function gitupdatetag ()
{
        #if [[ ! $# -eq 2 ]]
        #if test -z "$1" -o -z "$2"
        if test -z "$1"
        then 
                echo "Usage: gitupdatetag <yourtag>"
                return
        else
                echo "it works"
                TAG=$1
        fi
        echo "Deleting local tag $TAG ..."
        git tag -d $TAG
        echo "Deleting remote tag $TAG ..."
        git push origin :refs/tags/$TAG
        echo "Tagging current state of repo with  $TAG ..."
        git tag $TAG
        echo "Pusing tags ..."
        #git push --tags
		git push origin $TAG
}

STARTCOLOR='\e[0;34m\]';
ENDCOLOR="\e[0;32m\]";

#→ 

function parse_git_branch {
    git rev-parse --git-dir > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        git_status="$(git status 2> /dev/null)"
        branch_pattern="^# On branch ([^${IFS}]*)"
        detached_branch_pattern="# Not currently on any branch"
        remote_pattern="# Your branch is (.*) of"
        diverge_pattern="# Your branch and (.*) have diverged"
        untracked_pattern="# Untracked files:"
        new_pattern="new file:"
        not_staged_pattern="Changes not staged for commit"

        #files not staged for commit
        if [[ ${git_status}} =~ ${not_staged_pattern} ]]; then
            state="✔"
        fi
        # add an else if or two here if you want to get more specific
        # show if we're ahead or behind HEAD
        if [[ ${git_status} =~ ${remote_pattern} ]]; then
            if [[ ${BASH_REMATCH[1]} == "ahead" ]]; then
                remote="↑"
            else
                remote="↓"
            fi
        fi
        #new files
        if [[ ${git_status} =~ ${new_pattern} ]]; then
            remote="+"
        fi
        #untracked files
        if [[ ${git_status} =~ ${untracked_pattern} ]]; then
            remote="✖"
        fi
        #diverged branch
        if [[ ${git_status} =~ ${diverge_pattern} ]]; then
            remote="↕"
        fi
        #branch name
        if [[ ${git_status} =~ ${branch_pattern} ]]; then
            branch=${BASH_REMATCH[1]}
        #detached branch
        elif [[ ${git_status} =~ ${detached_branch_pattern} ]]; then
            branch="NO BRANCH"
        fi

        echo " ( ${branch} ${state}${remote})"
    fi
    return
}

#export PS1="\n\[\033[0;36m\]\@ \
#\[\033[1;30m\][\[\033[1;32m\]\u@\H\[\033[1;30m\]: \[\033[1;32m\]\w\
#\[\033[1;30m\]] \[\033[1;32m\] \n\$ \[\033[0;37m\]"

#export PS1="\n\[\033[0;36m\]\@ \
#\[\033[1;30m\][\[\033[1;32m\]\u@\H\[\033[1;30m\]: \[\033[1;32m\]\w\
#\[\033[1;30m\]] \[\033[1;32m\] \n\$ \[\033[0;37m\] \$(parse_git_branch)"
source ~/.scm_prompt

#export IDEA_JDK=/usr/java/latest/jre/
#export JAVA_HOME=/usr/java/latest/lib/
export IDEA_JDK=/usr/lib/jvm/java-1.6.0-openjdk.x86_64/

