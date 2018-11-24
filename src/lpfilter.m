function [H, D] = lpfilter(type, M, N, D0, n)

% 参考《数字图像处理MATLAB》一书

[U, V] = dftuv(M, N);

%  compute the distance D(U, V).
D = sqrt(U.^2 + V.^2);

% Begin filter computations
switch type
    case 'ideal'
        H = double(D <= D0);
    case 'btw'
        if nargin == 4      
            n = 1;          % default value
        end
        H = 1./(1 + (D./D0).^(2*n));
    case 'gaussian'
        H = exp(-(D.^2)./ (2*(D0^2)));
    otherwise
        error('Unknow filter type.')
end
end

