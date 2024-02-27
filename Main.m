clear;
clc;

%% 调用javaRobot类
javaaddpath('D:\Java\jdk-17\bin')  %文件相对路径
import java.awt.Robot;
import java.awt.event.*;
import java.awt.event.InputEvent;
% 创建Robot对象
robot = Robot();

%% 导入数据
%自引
%cd 'C:\Users\LENOVO\Desktop\第二次srtp\mydata\6、控制光标'
cd 'E:\桌面\srtp眼电\代码们\鼠标控制\控制光标'
codepath=pwd;

%引入数据所在文件位置
%cd 'C:\Users\LENOVO\Desktop\第二次srtp\mydata\6、控制光标'
cd 'E:\桌面\srtp眼电\代码们\鼠标控制\控制光标'
datapath=pwd;



%% 读取数据三个文件（可能之后做动态实验时这一部分代码要改）
fid0=fopen('EOG1.txt');   
c0=textscan(fid0,'%s %s %d %{hh:mm:ss}T %s %d %f');
fclose(fid0);

%c1为第二个信道数据  
fid1=fopen('EOG2.txt');   
c1=textscan(fid1,'%s %s %d %{hh:mm:ss}T %s %d %f');
fclose(fid1);

eeg1=c0{1,7};
eeg2=c1{1,7};
eeg=hampel([eeg1,eeg2]);

%eeg1,eeg{:,1}为第一信道，eeg2,eeg{:,2}为第二信道

%% 设置一些读取数据的参数
frame_T=10;        %在数据上框选子数据的频率
frame_move=50;     %节选框每次移动的距离
frame_length=700;  %框的大小
frame_energy=0.5;    %眼动能量达到此阈值才开始启动模型（范围是0-1）
frame_interval=1.5;%识别得到一个指令信号后，为了防止同一个指令动作被反复识别，间隔多长时间重新开始裁剪数据

mouse_T=10;        %鼠标每秒移动的次数
mouse_move=10;     %鼠标每次移动的距离

level = 7; % 小波变换的层数，可根据实际情况调整
wname = 'db4'; % 小波类型，可根据实际情况选择
alpha=1.5;%阈值倍数

%% 主程序

start=1;%从eeg的start位置开始裁剪数据
while true
    
%函数function [cut_data, time] = cutEOG(eeg, start, frame_T, frame_move, frame_length, frame_energy)
%寻找满足能量大于frame_energy的长frame_length的片段
%cut_data是符合条件的裁剪数据，time为此片段在eeg上的位置（初始位置和终止位置）
%如果没有符合条件的数据，time返回[-1,-1];cut_data返回[-1,-1]
[cut_data, time] = cutEOG(eeg, start, frame_T, frame_move, frame_length, frame_energy);

%更新时间
start=time(1,2);

%function wavelet_data=WaveLet(cut_data, level, wname, alpha)
%小波变换，返回滤波后的数据

wavelet_data=WaveLet(cut_data, level, wname, alpha);

%function features_data=Features(wavelet_data)
%提取裁剪信号的特征值
%最后的得到的features_data为一行18个特征值的数据

features_data=Features(wavelet_data);

%放入机器学习模型：
label_pre=1;

%根据预测得到的标签执行程序
switch label_pre
    case 1
        
        %向上移动
        while true
              % 获取当前鼠标位置
              mouseInfo = java.awt.MouseInfo.getPointerInfo();
              mouseLocation = mouseInfo.getLocation();
              x = mouseLocation.getX();
              y = mouseLocation.getY();
              % 将鼠标向上移动mouse_move个像素
              robot.mouseMove(x, y-mouse_move);
              
              %等待1/mouse_T，以免移动过快
              pause(1/mouse_T);
              
              %识别反向停止标签
              [cut_data, time] = cutEOG(eeg, start, frame_T, frame_move, frame_length, frame_energy);
              start=time(1,2);
              wavelet_data=WaveLet(cut_data, level, wname, alpha);
              features_data=Features(wavelet_data);
              %放入机器学习模型：
              label_pre=2;
              
              %停止信号
              if label_pre==2
                  break;
              end
              
        end 
        
    case 2
        
        %向下移动
        while true
              % 获取当前鼠标位置
              mouseInfo = java.awt.MouseInfo.getPointerInfo();
              mouseLocation = mouseInfo.getLocation();
              x = mouseLocation.getX();
              y = mouseLocation.getY();
              % 将鼠标向下移动mouse_move个像素
              robot.mouseMove(x, y+mouse_move);
              
              %等待1/mouse_T，以免移动过快
              pause(1/mouse_T);
              
              %识别反向停止标签
              [cut_data, time] = cutEOG(eeg, start, frame_T, frame_move, frame_length, frame_energy);
              start=time(1,2);
              wavelet_data=WaveLet(cut_data, level, wname, alpha);
              features_data=Features(wavelet_data);
              %放入机器学习模型：
              label_pre=1;
              
              %停止信号
              if label_pre==1
                  break;
              end  
            
        end 
        
    case 3
        
         %向右移动
        while true
              % 获取当前鼠标位置
              mouseInfo = java.awt.MouseInfo.getPointerInfo();
              mouseLocation = mouseInfo.getLocation();
              x = mouseLocation.getX();
              y = mouseLocation.getY();
              % 将鼠标向下移动mouse_move个像素
              robot.mouseMove(x+mouse_move, y);
              
              %等待1/mouse_T，以免移动过快
              pause(1/mouse_T);
              
              %识别反向停止标签
              [cut_data, time] = cutEOG(eeg, start, frame_T, frame_move, frame_length, frame_energy);
              start=time(1,2);
              wavelet_data=WaveLet(cut_data, level, wname, alpha);
              features_data=Features(wavelet_data);
              %放入机器学习模型：
              label_pre=4;
              
              %停止信号
              if label_pre==4
                  break;
              end  
            
        end 
        
    case 4
        
        %向左移动
        while true
              % 获取当前鼠标位置
              mouseInfo = java.awt.MouseInfo.getPointerInfo();
              mouseLocation = mouseInfo.getLocation();
              x = mouseLocation.getX();
              y = mouseLocation.getY();
              % 将鼠标向下移动mouse_move个像素
              robot.mouseMove(x-mouse_move, y);
              
              %等待1/mouse_T，以免移动过快
              pause(1/mouse_T);
              
              %识别反向停止标签
              [cut_data, time] = cutEOG(eeg, start, frame_T, frame_move, frame_length, frame_energy);
              start=time(1,2);
              wavelet_data=WaveLet(cut_data, level, wname, alpha);
              features_data=Features(wavelet_data);
              %放入机器学习模型：
              label_pre=3;
              
              %停止信号
              if label_pre==3
                  break;
              end  
            
        end 
        
    case 5
       %左键单击
       robot.mousePress  (java.awt.event.InputEvent.BUTTON1_MASK);
       robot.mouseRelease(java.awt.event.InputEvent.BUTTON1_MASK);
  
end

end

