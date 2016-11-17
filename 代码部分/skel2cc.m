function CCtext = skel2cc(MD_fo)

fskel = bwmorph(MD_fo, 'skel', inf);  % 求骨架



fskel_branch = bwmorph(fskel, 'branchpoints');     % 找分支点
% figure,imshow(fskel_branch)
fskel = fskel - fskel_branch;                      % 断开分支点
%figure,imshow(fskel)


DD = double(bwdist(~MD_fo));    % 计算该像素与最近非零像素的欧氏距离

%% 骨架恢复成连通分量，作者在文中没有说明如何恢复

t = linspace(0,2*pi,50);
ct = cos(t);
st = sin(t);

[L, num] = bwlabel(fskel, 8);   % 断开骨架的节点后，求8邻接骨架的数目，也就是论文所说的简单连通分量的数目
[r, c] = size(DD);
CCtext = zeros(size(MD_fo));    % 最终检测出的文字存放在这个数组里面

for k = 1:num                   % 对每一个断开的骨架都复原成连通分量，复原的目的是为了进行直线度和边缘密度判定
    [x, y] = find(L == k);
    D = zeros(size(DD));
    
    D(x, y) = DD(x, y);     % 骨架距离复制到D矩阵，目的是保留DD(x,y)？似乎复制过程也有些不对吧？有待优化！！！

    BW2 = false(r,c);       % 定义逻辑数组
    for j= 1:c
        for i = 1:r
            if D(i,j)==0
                continue
            end
            mask = poly2mask(D(i,j).*st + j, D(i,j).*ct + i, r, c); % 多边形转换成r×c大小的掩模
            % 上面这行代码相当于对骨架区域的每一个像素在其周围都产生一个圆形掩膜，掩膜大小为最近非零像素的欧氏距离
            BW2(mask) = true;
        end
    end
    % 求直线度
    Skellength = (length(x))^2;
    p1 = [x(1), y(1)];
    p2 = [x(end), y(end)];
    End_Distance = norm(p1 - p2);
    Straightness = Skellength/End_Distance;
    
    % 求边缘密度
    sobel_edge = edge(BW2, 'sobel'); 
    Edge_Length = sum(sum(sobel_edge));
    CC_Area = sum(sum(BW2));
    Edge_Density = Edge_Length/CC_Area;
    
    % 错误正样本剔除
    if (Edge_Density < 0.1) && (Straightness >= 1.1)
        %CCtext(:, :, k) = zeros(size(DD));
        continue;
    end
    CCtext(BW2) = 1;    
    

end

%figure, imshow(CCtext);
end
