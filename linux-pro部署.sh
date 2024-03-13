declare -A services=(
  ["module1"]="module1.jar"
  ["module2"]="module2.jar"
  ["module3"]="module3.jar"
)
# 日志文件列表
declare -A logFiles=(
  ["module1"]="module1.log"
  ["module2"]="module2.log"
  ["module3"]="module3.log"
)
# 目录列表
declare -A directories=(
  ["module1"]="module1"
  ["module2"]="module2"
  ["module3"]="module3"
)

#需要指定路径
jarDir="/home/jar"
function startService() {
  local serviceName=$1
  local packageName=${services[$serviceName]}
  local logFile=${logFiles[$serviceName]}
  
  if [ -n "$packageName" ]; then
    echo "启动 ${serviceName} 服务----------------------------------"
    cd ${jarDir}
    nohup java -Xmx500m -Xms500m -jar ${packageName} >> ${logFile} 2>&1 &
  else
    echo "未找到 ${serviceName} 对应的JAR包"
  fi
}

function stopService() {
  local serviceName=$1
  local packageName=${services[$serviceName]}
  
  if [ -n "$packageName" ]; then
    echo "停止 ${serviceName} 服务----------------------------------"
    pid=$(ps -ef | grep ${packageName} | grep -v grep | awk '{print $2}')
    if [ ${pid} ]; then
      kill -9 ${pid}
      echo "${serviceName} 服务已停止"
    else
      echo "${serviceName} 服务未运行"
    fi
  else
    echo "未找到 ${serviceName} 对应的JAR包"
  fi
}

function restartService() {
  local serviceName=$1
  stopService ${serviceName}
  sleep 3  # 等待3秒，确保服务完全关闭
  startService ${serviceName}
}

function startAll() {
  echo "启动所有服务----------------------------------"
  for serviceName in "${!services[@]}"; do
    startService ${serviceName}
  done
}

function stopAll() {
  echo "停止所有服务----------------------------------"
  for serviceName in "${!services[@]}"; do
    stopService ${serviceName}
  done
}

function restartAll() {
  echo "重启所有服务----------------------------------"
  for serviceName in "${!services[@]}"; do
    restartService ${serviceName}
  done
}

if [ $# -eq 2 ]; then
  case ${1} in
    "start")
      startService ${2}
      ;;
    "stop")
      stopService ${2}
      ;;
    "restart")
      restartService ${2}
      ;;
    *)
      echo "${1} 无效操作"
      ;;
  esac
elif [ $# -eq 1 ]; then
  case ${1} in
    "startAll")
      startAll
      ;;
    "stopAll")
      stopAll
      ;;
    "restartAll")
      restartAll
      ;;
    *)
      echo "${1} 无效操作"
      ;;
  esac
else
  echo "
  命令使用说明：
  start <服务名称>：启动指定服务
  stop <服务名称>：停止指定服务
  restart <服务名称>：重启指定服务
  startAll：启动所有服务
  stopAll：停止所有服务
  restartAll：重启所有服务
  示例命令如：./script.sh startAll
  无权限 使用 chmod u+x ./startup.sh
  记得需要安装java环境
  "
fi
