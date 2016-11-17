function text = Eliminate_false(text)
    se1 = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];  % 为了弥补汉字之间的空洞区域，所以我们使用闭运算
    text = imclose(text, se1);

    text = bwareaopen(text, 1000);      % 去除聚团像素个数少于1000个的连通分量，经验参数，阈值可以调节
    [L, num] = bwlabel(text, 8);

    for k = 1:num
        % 定义宽高比，以消除噪声，这里相当于假设了文字是水平的
        [x, y] = find(L == k);
        x = sort(x);
        y = sort(y);
        width = y(end)-y(1) + 1;
        height = x(end)-x(1) + 1;
        ration = width/height;   
        if ration < 2               % 因为前面做了膨胀运算，所以这里阈值可以设置的稍微大一点
            text(x, y) = 0;
            continue;
        end
        
    end

end

