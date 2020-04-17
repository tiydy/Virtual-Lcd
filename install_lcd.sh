#!/bin/bash

date=`date +%Y-%m-%d`
echo "$date 安装虚拟显示器"


#安装触摸屏驱动
function install_event()
{
	`cd event_drv;make clean &>compile;make &>compile`
	if [[ -f "./event_drv/event_drv.ko" ]]
	then
		echo "触摸屏安装成功"
	else 
		echo "触摸屏安装失败"
	fi
	`cd event_drv ;cp event_drv.ko ../virtual`
	`rm event_drv -rf`
}

#安装显示屏驱动
function install_lcd()
{
	`cd mmap_drv;make clean &>compile;make &>compile`
	if [[ -f "./mmap_drv/mmp_drv.ko" ]]
	then
		echo "LCD驱动安装成功"
	else
		echo "LCD驱动安装失败"
	fi
	`cd mmap_drv ;cp mmp_drv.ko ../virtual`
	`rm mmap_drv -rf`
}

#安装模拟器编译环境
function install_qt()
{
	echo "安装Qt编译环境中..."
	`sudo cp Qt5.12.0-hqd-shared.tar.bz2 /opt; cd /opt/;sudo tar -jxf Qt5.12.0-hqd-shared.tar.bz2; sudo rm Qt5.12.0-hqd-shared.tar.bz2`
	if [[ -f /opt/Qt5.12.0-hqd-shared/bin/qmake ]];then 
		echo "Qt安装成功"
	else
		echo "Qt安装失败"
		return -1
	fi
	
	`rm Qt5.12.0-hqd-shared.tar.bz2`
}

#安装模拟器
function install_virtual_lcd()
{
	echo "vlcd"
	`cd VirtualLcd ; /opt/Qt5.12.0-hqd-shared/bin/qmake; make clean &>compile;make &>compile`
	`cd VirtualLcd ; cp VirtualLcd ../virtual`;
	`rm VirtualLcd -rf`
}


`mkdir virtual`
if [[ -f "./Virtuallcd.tar.bz2" ]]
then
	echo "正在检测文件请稍等..."
	#解压
	`tar -jxf Virtuallcd.tar.bz2`
	if [[ $? == 1 ]];then exit -1; fi

	#文件存在
	echo "文件准备就绪...进入安装..."
	#安装触摸屏驱动
	install_event
	install_lcd
	install_qt
	install_virtual_lcd
	`mv lcd_event virtual`
	
	if [[ -f "./virtual/event_drv.ko" ]]
	then
		`sudo rmmod event_drv`
		`sudo insmod ./virtual/event_drv.ko`
	fi
	if [[ -f "./virtual/mmp_drv.ko" ]]
	then
		`sudo rmmod mmp_drv`
		`sudo insmod ./virtual/mmp_drv.ko`
	fi
	
	#启动模拟器
	echo "进入到lcd_event启动测试程序--要加sudo运行"
	echo "启动VirtualLcd模拟器显示---需要加sudo运行"


else
	echo "虚拟显示器安装包不存在"
fi

