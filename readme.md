# PAMI 2011 paper MATLAB复现
A Laplacian Approach to Multi-Oriented Text Detection in Video

# 运行说明

## 单张图片检测

1.	首先解压文件，找到src文件夹
2.	找到text_detect.m文件，这个文件可以进行单张图片检测
 

## 图片批量检测
batch\_text_detect.m是批量处理图片的程序。可以自动读取文件夹下的所有图片，然后进行文字检测，并且和标定好的结果进行比对，然后输出召回率和误警率。具体运行方式为，点开这个m文件:

- 更改想要检测图片所在的文件夹
- 建立一个目录用于存储检测结果的图片
- 使用importdata导入txt文件，这里面存储了我们标定好了的数据
- 设置目录将输出结果存储到刚才建立的目录中。
