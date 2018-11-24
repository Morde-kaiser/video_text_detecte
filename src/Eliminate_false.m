function text = Eliminate_false(text)
    se1 = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];  % Ϊ���ֲ�����֮��Ŀն�������������ʹ�ñ�����
    text = imclose(text, se1);

    text = bwareaopen(text, 1000);      % ȥ���������ظ�������1000������ͨ�����������������ֵ���Ե���
    [L, num] = bwlabel(text, 8);

    for k = 1:num
        % �����߱ȣ������������������൱�ڼ�����������ˮƽ��
        [x, y] = find(L == k);
        x = sort(x);
        y = sort(y);
        width = y(end)-y(1) + 1;
        height = x(end)-x(1) + 1;
        ration = width/height;   
        if ration < 2               % ��Ϊǰ�������������㣬����������ֵ�������õ���΢��һ��
            text(x, y) = 0;
            continue;
        end
        
    end

end

