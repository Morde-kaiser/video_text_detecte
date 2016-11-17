function CCtext = skel2cc(MD_fo)

fskel = bwmorph(MD_fo, 'skel', inf);  % ��Ǽ�



fskel_branch = bwmorph(fskel, 'branchpoints');     % �ҷ�֧��
% figure,imshow(fskel_branch)
fskel = fskel - fskel_branch;                      % �Ͽ���֧��
%figure,imshow(fskel)


DD = double(bwdist(~MD_fo));    % ���������������������ص�ŷ�Ͼ���

%% �Ǽָܻ�����ͨ����������������û��˵����λָ�

t = linspace(0,2*pi,50);
ct = cos(t);
st = sin(t);

[L, num] = bwlabel(fskel, 8);   % �Ͽ��ǼܵĽڵ����8�ڽӹǼܵ���Ŀ��Ҳ����������˵�ļ���ͨ��������Ŀ
[r, c] = size(DD);
CCtext = zeros(size(MD_fo));    % ���ռ��������ִ���������������

for k = 1:num                   % ��ÿһ���Ͽ��ĹǼܶ���ԭ����ͨ��������ԭ��Ŀ����Ϊ�˽���ֱ�߶Ⱥͱ�Ե�ܶ��ж�
    [x, y] = find(L == k);
    D = zeros(size(DD));
    
    D(x, y) = DD(x, y);     % �Ǽܾ��븴�Ƶ�D����Ŀ���Ǳ���DD(x,y)���ƺ����ƹ���Ҳ��Щ���԰ɣ��д��Ż�������

    BW2 = false(r,c);       % �����߼�����
    for j= 1:c
        for i = 1:r
            if D(i,j)==0
                continue
            end
            mask = poly2mask(D(i,j).*st + j, D(i,j).*ct + i, r, c); % �����ת����r��c��С����ģ
            % �������д����൱�ڶԹǼ������ÿһ������������Χ������һ��Բ����Ĥ����Ĥ��СΪ����������ص�ŷ�Ͼ���
            BW2(mask) = true;
        end
    end
    % ��ֱ�߶�
    Skellength = (length(x))^2;
    p1 = [x(1), y(1)];
    p2 = [x(end), y(end)];
    End_Distance = norm(p1 - p2);
    Straightness = Skellength/End_Distance;
    
    % ���Ե�ܶ�
    sobel_edge = edge(BW2, 'sobel'); 
    Edge_Length = sum(sum(sobel_edge));
    CC_Area = sum(sum(BW2));
    Edge_Density = Edge_Length/CC_Area;
    
    % �����������޳�
    if (Edge_Density < 0.1) && (Straightness >= 1.1)
        %CCtext(:, :, k) = zeros(size(DD));
        continue;
    end
    CCtext(BW2) = 1;    
    

end

%figure, imshow(CCtext);
end
