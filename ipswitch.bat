@echo off&color 0a&title IP地址快速切换器
echo ┌────────────────────────────┐
echo │                            │
echo │         请选择编号         │
echo │                            │
echo └────────────────────────────┘
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

:choice
set /p choice=请选择设置类型(1：自动获取IP / 2：机房网络 / 3：退出)：
if %choice%==1 goto auto
if %choice%==2 goto school_lan
if %choice%==3 (goto end) else (echo 输入错误，请重新输入&goto choice)


:lab_lan
set eth="以太网"
set ip=
set netmask=255.255.255.0
set gw=
set dns1=
set dns2=
echo.
echo 切换到外网有线环境
echo.
goto switch


:school_lan
set eth="以太网"
set ip=172.19.152.
set netmask=255.255.255.0
set gw=172.19.152.254
set dns1=202.106.196.115
set dns2=202.102.227.68
echo.
echo 切换到学校内网环境
echo.
goto switch

:switch
set code=
set /p code= 你的IP主机号[3-254]： %ip%
set "ip=%ip%%code%"
echo.
echo 正在设置IP地址 %ip%
netsh interface ip set address %eth% static %ip% %netmask% %gw% 1
echo 正在设置首选DNS服务器 %dns1%
netsh interface ip set dns %eth% static %dns1% register=PRIMARY validate=no
if defined dns2 (
    echo 正在设置备用DNS服务器 %dns2%
    netsh interface ip add dns %eth% %dns2% index=2 validate=no
)
echo 您的IP地址切换成功，当前IP地址为%ip%
echo.
goto choice


:auto
echo.
set eth="以太网"
echo 设置IP地址成功
netsh interface ip set address %eth% dhcp
echo 设置DNS地址成功
netsh interface ip set dns %eth% dhcp 
goto choice

:end
@echo on