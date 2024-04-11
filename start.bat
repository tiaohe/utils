@echo off
%1 mshta vbscript:CreateObject("WScript.Shell").run("%~s0 ::",0,FALSE)(window.close)&&exit
java -jar  -Xmx1024m -Xms1024m -Xmn300m -Xss128k xxx.jar >xxx.log 2>&1 &
exit
