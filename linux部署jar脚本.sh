# JAR包列表
jarPackages=(
  "package1.jar"
  "package2.jar"
  "package3.jar"
)

# JAR包所在目录
jarDir="/"

# 启动程序
function start() {
  echo "启动程序---------------------------------------------"

  # 进入JAR包所在目录
  cd ${jarDir}

  for packageName in "${jarPackages[@]}"; do
    nohup java -jar ${packageName} >> output.log 2>&1 &
  done

  # 查询是否有启动进程
  for packageName in "${jarPackages[@]}"; do
    getPid ${packageName}
    if [ ${pid} ]; then
      echo "${packageName} 已启动"
    else
      echo "${packageName} 启动失败"
    fi
  done
}

# 检测pid
getPid() {
  local packageName=$1
  echo "检测状态---------------------------------------------"
  pid=`ps -ef | grep -n ${packageName} | grep -v grep | awk '{print $2}'`
  if [ ${pid} ]; then
    echo "运行pid：${pid}"
  else
    echo "未运行"
  fi
}

# 停止所有程序
function stopAll() {
  echo "停止所有程序---------------------------------------------"

  for packageName in "${jarPackages[@]}"; do
    stop ${packageName}
  done
}

# 停止指定程序
function stop() {
  local packageName=$1
  getPid ${packageName}
  if [ ${pid} ]; then
    echo "停止程序---------------------------------------------"
    kill -9 ${pid}
    getPid ${packageName}
    if [ ${pid} ]; then
      echo "停止失败"
    else
      echo "停止成功"
    fi
  else
    echo "程序未运行"
  fi
}

# 启动时带参数，根据参数执行
if [ ${#} -ge 1 ]; then
  case ${1} in
    "start")
      start
      ;;
    "restart")
      stopAll
      start
      ;;
    "stop")
      stopAll
      ;;
    *)
      echo "${1}无任何操作"
      ;;
  esac
else
  echo "
  command如下命令：
  start：启动
  stop：停止进程
  restart：重启
  示例命令如：./startup.sh start
  无权限 使用 chmod u+x ./startup.sh
  记得需要安装java环境
  "
fi