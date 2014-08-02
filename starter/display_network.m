function [h, array] = display_network(A, opt_normalize, opt_graycolor, cols, opt_colmajor)
% This function visua u do not need to worry
% about it.
% opt_normalize: whether we need to normalize the filter so that all of
% them can have similar contrast. Default value Ĭ��ֵ is true.
% opt_graycolor: whether we use gray as the heat map. Default is true.
% cols����ֵ����ֵΪ8��: how many columns are there in the display. Default value is the
% squareroot of the number of columns in A.��
% opt_colmajor: you can switch convention to row major for A. In that
% case, each row of A is a filter. Default value is false.
warning off all
%��������opt_normalize�еı����Ƿ����
if ~exist('opt_normalize', 'var') || isempty(opt_normalize)
    opt_normalize= true;
end

if ~exist('opt_graycolor', 'var') || isempty(opt_graycolor)
    opt_graycolor= true;
end

if ~exist('opt_colmajor', 'var') || isempty(opt_colmajor)
    opt_colmajor = false;
end

% rescale
A = A - mean(A(:));
%colormap(gray) ���һ����ɫϵ������ͼ
if opt_graycolor, colormap(gray); end

% compute rows, cols
[L M]=size(A);
sz=sqrt(L);
buf=1;
if ~exist('cols', 'var')
    if floor(sqrt(M))^2 ~= M
        n=ceil(sqrt(M));
        while mod(M, n)~=0 && n<1.2*sqrt(M), n=n+1; end %���n=17��
        m=ceil(M/n); %mΪ12
    else
        n=sqrt(M);
        m=n;
    end
else
    n = cols;
    m = ceil(M/n);
end

array=-ones(buf+m*(sz+buf),buf+n*(sz+buf));%109*154�ľ���
%buf=1��m=12��n=17��sz=8��
if ~opt_graycolor
    array = 0.1.* array;
end


if ~opt_colmajor
    k=1;
    for i=1:m
        for j=1:n
            if k>M, 
                continue; 
            end
            clim=max(abs(A(:,k)));%ѡ��A�����е�K�������ֵ
            if opt_normalize%��array����ֵ��
                array(buf+(i-1)*(sz+buf)+(1:sz),buf+(j-1)*(sz+buf)+(1:sz))=reshape(A(:,k),sz,sz)/clim;
            else
                array(buf+(i-1)*(sz+buf)+(1:sz),buf+(j-1)*(sz+buf)+(1:sz))=reshape(A(:,k),sz,sz)/max(abs(A(:)));
            end
            k=k+1;
        end
    end
else
    k=1;
    for j=1:n
        for i=1:m
            if k>M, 
                continue; 
            end
            clim=max(abs(A(:,k)));
            if opt_normalize
                array(buf+(i-1)*(sz+buf)+(1:sz),buf+(j-1)*(sz+buf)+(1:sz))=reshape(A(:,k),sz,sz)/clim;
            else
                array(buf+(i-1)*(sz+buf)+(1:sz),buf+(j-1)*(sz+buf)+(1:sz))=reshape(A(:,k),sz,sz);
            end
            k=k+1;
        end
    end
end

if opt_graycolor
    h=imagesc(array,'EraseMode','none',[-1 1]);%ϵͳ�Դ���imagesc����������
else
    h=imagesc(array,'EraseMode','none',[-1 1]);
    %��array�е���������ӳ�䵽[-1,1]֮�䣬Ȼ��ʹ�õ�ǰ���õ���ɫ�������ʾ��
    %��ʱ��[-1,1]������������ɫ����������ģʽ����Ϊnode����ʾ������������
end
axis image off

drawnow;

warning on all
