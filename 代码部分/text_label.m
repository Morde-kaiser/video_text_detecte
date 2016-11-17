 % 读取图片，标定出文字区域并且存入文件text_block1.txt中，注意，图片是按名称排序的,text_block1中的1对于文件夹名称的第一数字1
 % 每一个文件夹中的数据分别存在一个txt文件中，文件的最后一列表示该图片的文字个数
 function text_label
    close all;
   
    P = '/Volumes/Macintosh HD/Users/mordekaiser/Documents/研一下学期/图像分析与应用/叠加文字数据集/12_先婚后友/';   
    % 注意，如果更换了路径，那么需要更换保存的txt的文件名，不然新数据会覆盖老数据
 
	D = dir([P '*.bmp']);
    text_block = zeros(length(D), 9);  
    % 存储每一副图片的文字区域的位置，即左上角点的坐标，以及矩形的宽度和高度
    % 中文部分：x1_min, y1_min, width1,height1;注意，实际裁剪的图像的宽度，高度是width1+1, height1+1
    
    % 英文部分：x2_min,y2_min,width2,height2
    % 第9列存储真是的文字快的个数
    for i = 1 : length(D)
        img = imread([P D(i).name]);
        figure, imshow(img);
         
        text_block(i, 9) = 2;    % 这里为了方便标定，假设每张图片最多就2个文字块，如果有必要，可以自己拓展
        [~, rect1] = imcrop(img);       % 选中文字区域，裁剪文字, rect返回左上角的竖直索引，和水平方向的索引，以及宽度，高度
                                        % 注意，不是返回水平和竖直索引，这里不同于一般情况，所有为了方便我们的使用习惯，下面存储数据前
                                        % 进行行与行之间的交换
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
     
        % 交换位置，交换理由前面已经说明
        rect1([1 2]) = rect1([2 1]);
        rect2([1 2]) = rect2([2 1]);

        
        text_block(i, 1:8) = [rect1(:)', rect2(:)'];
        text_block = round(text_block);
%        fprintf('%f %f\n', rect1, rect2);  % 输出裁剪区域的文字坐标

    end
    save text_block12.txt -ascii text_block;
end

