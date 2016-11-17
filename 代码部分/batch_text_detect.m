function batch_text_detect
close all;
clear all;
P = '/Volumes/Macintosh HD/Users/mordekaiser/Documents/研一下学期/图像分析与应用/叠加文字数据集/2_非常人贩2A/';   % 运行不同的数据要更改
mkdir('/Volumes/Macintosh HD/Users/mordekaiser/Documents/研一下学期/图像分析与应用/叠加文字数据集/2_result/');  % 结果存放路径，每次运行不同数据要更该
D = dir([P '*.bmp']);
truth_text_block = importdata('text_block2.txt');       % 导入标定好的数据，每次运行不同的数据需要进行更改

% 定义几个参量，真实的文字块，正确检测的文字块，检测到的文字块，错误检测的文字块
truth_text = zeros(length(D), 1);       % 每个元素存储各个图片正确的检测数目
correct_detect = zeros(length(D), 1);
num_detect = zeros(length(D), 1);
num_false_text = zeros(length(D), 1);

%truth_text_block = truth_text_block';           % 原来数据是按行存储的，需要做转置
for i = 1:length(D)
    
    % 初始化
    truth_text(i) = truth_text_block(i, 9);
    correct_detect(i) = 0;      % 正确检测文本数目,每一次比对成功就加1

    
    
    
    img = imread([P D(i).name]);
    [text, img_output] = text_detect(img);        % 标出了检测到的文字区域，并且是直接在图片上进行修改的
    
%           if truth_text(i) == 0        % 如果有文字，就显示，不然就不显示
%          
%               [L, num] = bwlabel(text, 8);
%          num_detect(i) = num;   
%          fprintf('\n图片');
%          fprintf('%d', i);
%          fprintf('检测结果:\n');
%          fprintf('实际文字数量:');
%          fprintf('%d    ', truth_text(i));
%          fprintf('检测出的文本数量:');
%          fprintf('%d    ', num_detect(i));
%          fprintf('正确检测的文本数:');
%          fprintf('%d    ', correct_detect(i));
%          
%          num_false_text(i) = num_detect(i) - correct_detect(i);
%          
%          fprintf('错误检测的文本数:');
%          fprintf('%d    ', num_false_text(i));
%         
%         imwrite(img_output,['/Volumes/Macintosh HD/Users/mordekaiser/Documents/研一下学期/图像分析与应用/叠加文字数据集/2_result/',num2str(i),'.bmp']);      % 运行不同的数据要更改
%         end
             
        ground_truth = (reshape(truth_text_block(i, 1:8), 4, 2))';   % ground truth的每一行代表一个文字区域
        
                 
              
          % 画出正确的标定区域，用绿色表示
          for j = 1:2           % 标出所有文字块的位置，要是文字块个数发生改变，这里也要变
             if (ground_truth(j, 3)) == 0 && (ground_truth(j, 4) == 0)       % 如果文字区域少于两行，加入判断语句，对于0宽度的文字跳过标记
                 continue;
             end
              img_output(ground_truth(j,1):(ground_truth(j,1)+ground_truth(j,4)), ground_truth(j,2), 2) = 255;
             img_output(ground_truth(j,1), ground_truth(j,2):(ground_truth(j,2)+ground_truth(j,3)), 2) = 255;
             img_output((ground_truth(j,1)+ground_truth(j,4)), ground_truth(j,2):(ground_truth(j,2)+ground_truth(j,3)), 2) = 255;
             img_output(ground_truth(j,1):(ground_truth(j,1)+ground_truth(j,4)), ground_truth(j,2)+ground_truth(j,3), 2) = 255;
          end
             % figure, imshow(img_output);
     
              
    % 下面是比对重合区域的过程
    [L, num] = bwlabel(text, 8);
    num_detect(i) = num;
    
    
    for k = 1:num
            
        cc_rect = zeros(2, 2);  % 临时变量，用于存储单个文字连通分量
        [x, y] = find(L == k);
         x = sort(x);
         y = sort(y);
         cc_rect = [x(1), y(1), y(end)-y(1)+1, x(end)-x(1)+1];
         d_aera = cc_rect(3) * cc_rect(4);
         
         ground_detected = zeros(size(text));
         ground_detected(x(1):x(end), y(1):y(end)) = 1;


         for j = 1:2      % 把标定好的文字区域拿来和检测的区域做对比，标定的图片最多就两个文字块
             if (ground_truth(j, 3)) == 0 && (ground_truth(j, 4) == 0)       % 如果文字区域少于两行，加入判断语句，对于0宽度的文字跳过面积比对
                 continue;
             end
             ground = zeros(size(text));
             ground(ground_truth(j,1):(ground_truth(j,1)+ground_truth(j,4)), ...
              ground_truth(j,2):(ground_truth(j,2)+ground_truth(j,3))) = 1;

             
            concide = ground & ground_detected;  % 重合部分
            o_aera = length(find(concide == 1));  % 重合面积
            g_aera = (ground_truth(j, 3)) * (ground_truth(j, 4));

          
          if ((o_aera/g_aera)>0.95) && ((o_aera/d_aera)>0.75)
              correct_detect(i) = correct_detect(i) + 1;
          end
        end

    end
         fprintf('\n图片');
         fprintf('%d', i);
         fprintf('检测结果:\n');
         fprintf('实际文字数量:');
         fprintf('%d    ', truth_text(i));
         fprintf('检测出的文本数量:');
         fprintf('%d    ', num_detect(i));
         fprintf('正确检测的文本数:');
         fprintf('%d    ', correct_detect(i));
         
         num_false_text(i) = abs(num_detect(i) - correct_detect(i));
         
         fprintf('错误检测的文本数:');
         fprintf('%d    ', num_false_text(i));
        
        imwrite(img_output,['/Volumes/Macintosh HD/Users/mordekaiser/Documents/研一下学期/图像分析与应用/叠加文字数据集/2_result/',num2str(i),'.bmp']);      % 运行不同的数据要更改
end

recall = sum(correct_detect)/sum(truth_text);
false_alarm_rate = sum(num_false_text)/sum(num_detect);


fprintf('\n所给数据集的召回率是:');
fprintf('%d', recall);

fprintf('\n所给数据集的误警率是:');
fprintf('%d\n', false_alarm_rate);


end
