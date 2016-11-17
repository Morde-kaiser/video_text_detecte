%% 文字检测程序，参考论文：A Laplacian Approach to Multi-Oriented Text Detection in Video
%% 关于参数选取
% 滤波器参数D0作者没有给出，这里取填充后宽度的0.8倍
% 计算MD值的N = 21
% 直线度和边缘密度的阈值分别为0.05和1.4（作者用的是0.1和1.2）
%% 关于运行时间
% 1024×576（取自冰河世纪）大小的图片运行约45秒
% 640×360（取自非常人贩2A）大小的图片运行约12秒
% 其他暂不列出
%% 关于算法性能
% 检测效果很一般，有相当高的错误检测率。漏检文字的情况相对较小，但是很多
% 非文字区域被误检测为文字。
function  [text, img_output] = text_detect(img_input)
%% 图像读取以及滤波
% tic;                              % 计算程序的执行时间
img_input = imread('文件夹11内的某张图片.bmp');        % 如果批量图片检测的时候，这句一定要注释掉
figure, imshow(img_input);
title('原图像');

channels = size(img_input, 3);      % 若是RGB图，则转成灰度图像
if(channels>1)
    img=rgb2gray(img_input);
end
% figure, imshow(img);         
% 程序里面能看到很多上面这种类似的注释，是为了方便查看算法每一步的结果，所以我们保留了在这里

PQ = paddesize(size(img));          % 图像填充
D0 = 0.8 * PQ(2);       % 理想低通滤波器参数设置，模糊范围是填充后宽度的0.8倍
                        % 因为所给数据噪声比较小，模糊程度可以比较低，即D0可以比较大          
ideal_lp = lpfilter('ideal', PQ(1), PQ(2), D0); % 理想低通滤波
% figure,imshow(fftshift(H));

[U, V] = dftuv(PQ(1), PQ(2));   % 计算网格数据，即U, V的离散取样点，取样点集的中心在原点
laplican = -4 * (U.^2 + V.^2);
H = ideal_lp .* laplican;
% figure, imshow(log(1+abs(fftshift(laplican))), []);

img_filted = dftfilt(img, H);       % matlab只有空域拉普拉斯滤波函数，没有频域滤波的函数，所以这里自己写了一个
% figure;imshow(img_filted, []);

%% 计算MD图，是文字区域聚成“团块”
[M, N] = size(img_filted);
MD = zeros(M, N);
paded = zeros(M + 20, N + 20);
paded(11:(end-10), 11:(end-10)) = img_filted;
for i = 1 : M
    for j = 1 : N
        MD(i, j) = max(paded(i + 10, j : j+20)) - min(paded(i + 10, j : j+20));
    end
end
% figure;imshow(MD, []);

se = strel('square', 5);    % 作者说用开操作，去除毛刺，但这个是灰度形态学处理
                            % 结构元大小是自己选的，作者没有说明
MD_fo = imopen(MD, se);
% figure,imshow(MD_fo, []);  

%% 使用K?means分成两类，这个过程相当于一个二值化的过程，但是不需要阈值
MD_fo = MD_fo(:);   % 把图像展成列向量
[Idx, C] = kmeans(MD_fo, 2, 'dist', 'sqEuclidean'); % Idx是各个像素的所属类, C是各类的均值
[~, index] = max(C);    % 返回均值更大的那一类的索引
MD_fo(Idx == index) = 1;    % 均值更大的那一类就认为是文字类，并复制为1
MD_fo(Idx ~= index) = 0;
MD_fo = reshape(MD_fo, M, N);
%MD_erode = bwmorph(MD_fo,'erode');
% figure,imshow(MD_fo);
%% 对连通分量求骨架，然后断开骨架，而后把骨架转换成连通分量，然后进行错误的正样本剔除，然后返回文字区域的二值图
text = skel2cc(MD_fo);


text = Eliminate_false(text);   % 错误正样本剔除，利用长宽比等信息


%figure, imshow(text);
[L, num] = bwlabel(text, 8);
% fprintf('检测出的文本数量：');
% fprintf('%d', num);
% 标记出检测的文本
for k = 1:num           % 根据左上角和有下角的点，框出连通分量
    [x, y] = find(L == k);
     x = sort(x);
     y = sort(y);
     img_input(x(1):x(end), y(1), 1) = 255;
     img_input(x(1), y(1):y(end), 1) = 255;
     img_input(x(end), y(1):y(end), 1) = 255;
     img_input(x(1):x(end), y(end), 1) = 255;
end

img_output = img_input;
figure, imshow(img_input);
title('文字检测结果');
% toc
end




