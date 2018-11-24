function batch_text_detect
close all;
clear all;
P = '/Volumes/Macintosh HD/Users/mordekaiser/Documents/��һ��ѧ��/ͼ�������Ӧ��/�����������ݼ�/2_�ǳ��˷�2A/';   % ���в�ͬ������Ҫ����
mkdir('/Volumes/Macintosh HD/Users/mordekaiser/Documents/��һ��ѧ��/ͼ�������Ӧ��/�����������ݼ�/2_result/');  % ������·����ÿ�����в�ͬ����Ҫ����
D = dir([P '*.bmp']);
truth_text_block = importdata('text_block2.txt');       % ����궨�õ����ݣ�ÿ�����в�ͬ��������Ҫ���и���

% ���弸����������ʵ�����ֿ飬��ȷ�������ֿ飬��⵽�����ֿ飬����������ֿ�
truth_text = zeros(length(D), 1);       % ÿ��Ԫ�ش洢����ͼƬ��ȷ�ļ����Ŀ
correct_detect = zeros(length(D), 1);
num_detect = zeros(length(D), 1);
num_false_text = zeros(length(D), 1);

%truth_text_block = truth_text_block';           % ԭ�������ǰ��д洢�ģ���Ҫ��ת��
for i = 1:length(D)
    
    % ��ʼ��
    truth_text(i) = truth_text_block(i, 9);
    correct_detect(i) = 0;      % ��ȷ����ı���Ŀ,ÿһ�αȶԳɹ��ͼ�1

    
    
    
    img = imread([P D(i).name]);
    [text, img_output] = text_detect(img);        % ����˼�⵽���������򣬲�����ֱ����ͼƬ�Ͻ����޸ĵ�
    
%           if truth_text(i) == 0        % ��������֣�����ʾ����Ȼ�Ͳ���ʾ
%          
%               [L, num] = bwlabel(text, 8);
%          num_detect(i) = num;   
%          fprintf('\nͼƬ');
%          fprintf('%d', i);
%          fprintf('�����:\n');
%          fprintf('ʵ����������:');
%          fprintf('%d    ', truth_text(i));
%          fprintf('�������ı�����:');
%          fprintf('%d    ', num_detect(i));
%          fprintf('��ȷ�����ı���:');
%          fprintf('%d    ', correct_detect(i));
%          
%          num_false_text(i) = num_detect(i) - correct_detect(i);
%          
%          fprintf('��������ı���:');
%          fprintf('%d    ', num_false_text(i));
%         
%         imwrite(img_output,['/Volumes/Macintosh HD/Users/mordekaiser/Documents/��һ��ѧ��/ͼ�������Ӧ��/�����������ݼ�/2_result/',num2str(i),'.bmp']);      % ���в�ͬ������Ҫ����
%         end
             
        ground_truth = (reshape(truth_text_block(i, 1:8), 4, 2))';   % ground truth��ÿһ�д���һ����������
        
                 
              
          % ������ȷ�ı궨��������ɫ��ʾ
          for j = 1:2           % ����������ֿ��λ�ã�Ҫ�����ֿ���������ı䣬����ҲҪ��
             if (ground_truth(j, 3)) == 0 && (ground_truth(j, 4) == 0)       % ������������������У������ж���䣬����0��ȵ������������
                 continue;
             end
              img_output(ground_truth(j,1):(ground_truth(j,1)+ground_truth(j,4)), ground_truth(j,2), 2) = 255;
             img_output(ground_truth(j,1), ground_truth(j,2):(ground_truth(j,2)+ground_truth(j,3)), 2) = 255;
             img_output((ground_truth(j,1)+ground_truth(j,4)), ground_truth(j,2):(ground_truth(j,2)+ground_truth(j,3)), 2) = 255;
             img_output(ground_truth(j,1):(ground_truth(j,1)+ground_truth(j,4)), ground_truth(j,2)+ground_truth(j,3), 2) = 255;
          end
             % figure, imshow(img_output);
     
              
    % �����Ǳȶ��غ�����Ĺ���
    [L, num] = bwlabel(text, 8);
    num_detect(i) = num;
    
    
    for k = 1:num
            
        cc_rect = zeros(2, 2);  % ��ʱ���������ڴ洢����������ͨ����
        [x, y] = find(L == k);
         x = sort(x);
         y = sort(y);
         cc_rect = [x(1), y(1), y(end)-y(1)+1, x(end)-x(1)+1];
         d_aera = cc_rect(3) * cc_rect(4);
         
         ground_detected = zeros(size(text));
         ground_detected(x(1):x(end), y(1):y(end)) = 1;


         for j = 1:2      % �ѱ궨�õ��������������ͼ����������Աȣ��궨��ͼƬ�����������ֿ�
             if (ground_truth(j, 3)) == 0 && (ground_truth(j, 4) == 0)       % ������������������У������ж���䣬����0��ȵ�������������ȶ�
                 continue;
             end
             ground = zeros(size(text));
             ground(ground_truth(j,1):(ground_truth(j,1)+ground_truth(j,4)), ...
              ground_truth(j,2):(ground_truth(j,2)+ground_truth(j,3))) = 1;

             
            concide = ground & ground_detected;  % �غϲ���
            o_aera = length(find(concide == 1));  % �غ����
            g_aera = (ground_truth(j, 3)) * (ground_truth(j, 4));

          
          if ((o_aera/g_aera)>0.95) && ((o_aera/d_aera)>0.75)
              correct_detect(i) = correct_detect(i) + 1;
          end
        end

    end
         fprintf('\nͼƬ');
         fprintf('%d', i);
         fprintf('�����:\n');
         fprintf('ʵ����������:');
         fprintf('%d    ', truth_text(i));
         fprintf('�������ı�����:');
         fprintf('%d    ', num_detect(i));
         fprintf('��ȷ�����ı���:');
         fprintf('%d    ', correct_detect(i));
         
         num_false_text(i) = abs(num_detect(i) - correct_detect(i));
         
         fprintf('��������ı���:');
         fprintf('%d    ', num_false_text(i));
        
        imwrite(img_output,['/Volumes/Macintosh HD/Users/mordekaiser/Documents/��һ��ѧ��/ͼ�������Ӧ��/�����������ݼ�/2_result/',num2str(i),'.bmp']);      % ���в�ͬ������Ҫ����
end

recall = sum(correct_detect)/sum(truth_text);
false_alarm_rate = sum(num_false_text)/sum(num_detect);


fprintf('\n�������ݼ����ٻ�����:');
fprintf('%d', recall);

fprintf('\n�������ݼ���������:');
fprintf('%d\n', false_alarm_rate);


end
