%% ���ּ����򣬲ο����ģ�A Laplacian Approach to Multi-Oriented Text Detection in Video
%% ���ڲ���ѡȡ
% �˲�������D0����û�и���������ȡ�����ȵ�0.8��
% ����MDֵ��N = 21
% ֱ�߶Ⱥͱ�Ե�ܶȵ���ֵ�ֱ�Ϊ0.05��1.4�������õ���0.1��1.2��
%% ��������ʱ��
% 1024��576��ȡ�Ա������ͣ���С��ͼƬ����Լ45��
% 640��360��ȡ�Էǳ��˷�2A����С��ͼƬ����Լ12��
% �����ݲ��г�
%% �����㷨����
% ���Ч����һ�㣬���൱�ߵĴ������ʡ�©�����ֵ������Խ�С�����Ǻܶ�
% ��������������Ϊ���֡�
function  [text, img_output] = text_detect(img_input)
%% ͼ���ȡ�Լ��˲�
% tic;                              % ��������ִ��ʱ��
img_input = imread('�ļ���11�ڵ�ĳ��ͼƬ.bmp');        % �������ͼƬ����ʱ�����һ��Ҫע�͵�
figure, imshow(img_input);
title('ԭͼ��');

channels = size(img_input, 3);      % ����RGBͼ����ת�ɻҶ�ͼ��
if(channels>1)
    img=rgb2gray(img_input);
end
% figure, imshow(img);         
% ���������ܿ����ܶ������������Ƶ�ע�ͣ���Ϊ�˷���鿴�㷨ÿһ���Ľ�����������Ǳ�����������

PQ = paddesize(size(img));          % ͼ�����
D0 = 0.8 * PQ(2);       % �����ͨ�˲����������ã�ģ����Χ�������ȵ�0.8��
                        % ��Ϊ�������������Ƚ�С��ģ���̶ȿ��ԱȽϵͣ���D0���ԱȽϴ�          
ideal_lp = lpfilter('ideal', PQ(1), PQ(2), D0); % �����ͨ�˲�
% figure,imshow(fftshift(H));

[U, V] = dftuv(PQ(1), PQ(2));   % �����������ݣ���U, V����ɢȡ���㣬ȡ���㼯��������ԭ��
laplican = -4 * (U.^2 + V.^2);
H = ideal_lp .* laplican;
% figure, imshow(log(1+abs(fftshift(laplican))), []);

img_filted = dftfilt(img, H);       % matlabֻ�п���������˹�˲�������û��Ƶ���˲��ĺ��������������Լ�д��һ��
% figure;imshow(img_filted, []);

%% ����MDͼ������������۳ɡ��ſ顱
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

se = strel('square', 5);    % ����˵�ÿ�������ȥ��ë�̣�������ǻҶ���̬ѧ����
                            % �ṹԪ��С���Լ�ѡ�ģ�����û��˵��
MD_fo = imopen(MD, se);
% figure,imshow(MD_fo, []);  

%% ʹ��K?means�ֳ����࣬��������൱��һ����ֵ���Ĺ��̣����ǲ���Ҫ��ֵ
MD_fo = MD_fo(:);   % ��ͼ��չ��������
[Idx, C] = kmeans(MD_fo, 2, 'dist', 'sqEuclidean'); % Idx�Ǹ������ص�������, C�Ǹ���ľ�ֵ
[~, index] = max(C);    % ���ؾ�ֵ�������һ�������
MD_fo(Idx == index) = 1;    % ��ֵ�������һ�����Ϊ�������࣬������Ϊ1
MD_fo(Idx ~= index) = 0;
MD_fo = reshape(MD_fo, M, N);
%MD_erode = bwmorph(MD_fo,'erode');
% figure,imshow(MD_fo);
%% ����ͨ������Ǽܣ�Ȼ��Ͽ��Ǽܣ�����ѹǼ�ת������ͨ������Ȼ����д�����������޳���Ȼ�󷵻���������Ķ�ֵͼ
text = skel2cc(MD_fo);


text = Eliminate_false(text);   % �����������޳������ó���ȵ���Ϣ


%figure, imshow(text);
[L, num] = bwlabel(text, 8);
% fprintf('�������ı�������');
% fprintf('%d', num);
% ��ǳ������ı�
for k = 1:num           % �������ϽǺ����½ǵĵ㣬�����ͨ����
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
title('���ּ����');
% toc
end




