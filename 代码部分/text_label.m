 % ��ȡͼƬ���궨�����������Ҵ����ļ�text_block1.txt�У�ע�⣬ͼƬ�ǰ����������,text_block1�е�1�����ļ������Ƶĵ�һ����1
 % ÿһ���ļ����е����ݷֱ����һ��txt�ļ��У��ļ������һ�б�ʾ��ͼƬ�����ָ���
 function text_label
    close all;
   
    P = '/Volumes/Macintosh HD/Users/mordekaiser/Documents/��һ��ѧ��/ͼ�������Ӧ��/�����������ݼ�/12_�Ȼ����/';   
    % ע�⣬���������·������ô��Ҫ���������txt���ļ�������Ȼ�����ݻḲ��������
 
	D = dir([P '*.bmp']);
    text_block = zeros(length(D), 9);  
    % �洢ÿһ��ͼƬ�����������λ�ã������Ͻǵ�����꣬�Լ����εĿ�Ⱥ͸߶�
    % ���Ĳ��֣�x1_min, y1_min, width1,height1;ע�⣬ʵ�ʲü���ͼ��Ŀ�ȣ��߶���width1+1, height1+1
    
    % Ӣ�Ĳ��֣�x2_min,y2_min,width2,height2
    % ��9�д洢���ǵ����ֿ�ĸ���
    for i = 1 : length(D)
        img = imread([P D(i).name]);
        figure, imshow(img);
         
        text_block(i, 9) = 2;    % ����Ϊ�˷���궨������ÿ��ͼƬ����2�����ֿ飬����б�Ҫ�������Լ���չ
        [~, rect1] = imcrop(img);       % ѡ���������򣬲ü�����, rect�������Ͻǵ���ֱ��������ˮƽ������������Լ���ȣ��߶�
                                        % ע�⣬���Ƿ���ˮƽ����ֱ���������ﲻͬ��һ�����������Ϊ�˷������ǵ�ʹ��ϰ�ߣ�����洢����ǰ
                                        % ����������֮��Ľ���
        % RECT is a 4-element vector with the form [XMIN YMIN WIDTH HEIGHT];
        [~, rect2] = imcrop(img);
        

        
        if isempty(rect1)
            rect1 = zeros(2, 2);
            text_block(i, 9) = text_block(i, 9)-1; 
        end
        if isempty(rect2)
            rect2 = zeros(2, 2);
            text_block(i, 9) = text_block(i, 9)-1;
        end
     
        % ����λ�ã���������ǰ���Ѿ�˵��
        rect1([1 2]) = rect1([2 1]);
        rect2([1 2]) = rect2([2 1]);

        
        text_block(i, 1:8) = [rect1(:)', rect2(:)'];
        text_block = round(text_block);
%        fprintf('%f %f\n', rect1, rect2);  % ����ü��������������

    end
    save text_block12.txt -ascii text_block;
end

