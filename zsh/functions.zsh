function mcd() {
	mkdir -p $1 && cd $1
}

# Copy with a progress bar
function cp_p()
{
   strace -q -ewrite cp -- "${1}" "${2}" 2>&1 \
      | awk '{
        count += $NF
            if (count % 10 == 0) {
               percent = count / total_size * 100
               printf "%3d%% [", percent
               for (i=0;i<=percent;i++)
                  printf "="
               printf ">"
               for (i=percent;i<100;i++)
                  printf " "
               printf "]\r"
            }
         }
         END { print "" }' total_size=$(stat -c '%s' "${1}") count=0
}

function up()
{
  local DIR=$PWD
  local TARGET=$1
  while [ ! -e $DIR/$TARGET -a $DIR != "/" ]; do
    DIR=$(dirname $DIR)
  done
  test $DIR != "/" && echo $DIR/$TARGET
}

function cdup()
{
  if [ "$1" != "" ]; then
    TARGET=$*
  else
    TARGET=.git
  fi

  DIR=`up $TARGET`

  if [ "$DIR" != "" ]; then
    if [ `basename "$DIR"` = ".git" ]; then
      cd `dirname $DIR`
    else
      cd $DIR
    fi
  fi
}

