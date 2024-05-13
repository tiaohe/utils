@echo off
setlocal enabledelayedexpansion

rem 设置要关闭的端口号
set PORT=%1

rem 查找占用指定端口的 PID
for /f "tokens=5" %%a in ('netstat -aon ^| findstr /R "\<%PORT%\>"') do (
    set PID=%%a
)

rem 如果找到了 PID，则关闭对应进程
if defined PID (
    echo 关闭端口 %PORT% 对应的进程 (PID: !PID!)
    taskkill /F /PID !PID! >nul 2>&1
    rem 清除 PID 变量
    set "PID="
) else (
    rem 没有找到占用端口的进程时不进行任何操作
)

endlocal
