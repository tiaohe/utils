@echo off

rem 检查并关闭指定端口的服务
set port=xxx
for /f "tokens=1-5" %%i in ('netstat -ano^|findstr ":%port%"') do (
    echo kill the process %%m who use the port %port%
    taskkill /f /pid %%m
)
rem   睡眠3秒
timeout /T 3 /NOBREAK

rem 启动Java服务
%1 mshta vbscript:CreateObject("WScript.Shell").run("%~s0 ::",0,FALSE)(window.close)&&exit
java -jar  -Xmx1024m -Xms1024m -Xmn300m -Xss128k xxx.jar >xxx.log 2>&1 &

exit
