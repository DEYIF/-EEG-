%小波变换，返回滤波后的数据
function wavelet_data=WaveLet(cut_data, level, wname, alpha)

wavelet_data=[];

sig_afterLPF=cut_data;

%进行小波变换
for i=1:1:(size(sig_afterLPF,2)/2)%这个数据只有两列，但是为了防止多列数据出现，所以用了size来计算

    sig_afterLPF(:,2*i-1) = (sig_afterLPF(:,2*i-1) - mean(sig_afterLPF(:,2*i-1))) / std(sig_afterLPF(:,2*i-1));
    [a1, l1] = wavedec(sig_afterLPF(:,2*i-1), level, wname);
    thr1 = alpha*sqrt(2*log(length(sig_afterLPF(:,2*i-1))))*median(abs(a1)) / 0.6745;
    sig_afterLPF(:,2*i) = (sig_afterLPF(:,2*i) - mean(sig_afterLPF(:,2*i))) / std(sig_afterLPF(:,2*i));
    [a2, l2] = wavedec(sig_afterLPF(:,2*i), level, wname);
    thr2 = alpha*sqrt(2*log(length(sig_afterLPF(:,2*i))))*median(abs(a2)) / 0.6745;
    s1 = wthresh(a1, 's', thr1);
    s1 = waverec(s1, l1, wname);
    s2 = wthresh(a2, 's', thr1);
    s2 = waverec(s2, l2, wname);

    wavelet_data=[wavelet_data,s1];

    wavelet_data=[wavelet_data,s2];

end

end
