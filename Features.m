%提取裁剪信号的特征值
%最后的得到的features_data为一行18个特征值的数据

function features_data=Features(wavelet_data)

data=wavelet_data;

% 获取数据列数
num_columns = size(data, 2);

% 初始化特征矩阵
features_data = zeros(num_columns/2 , 2 * 9); % 9是时域和频域特征的总数

% 循环处理每两列数据
for i = 1:2:num_columns%和滤波数据一样，防止出现多个列，所以用了size
    % 提取一对数据
    temp=[];

    channel1 = data(:, i);
    channel2 = data(:, i + 1);

    % 时域特征
    rms_value = rms(channel1);
    temp=[temp,rms_value];
    rms_value = rms(channel2);
    temp=[temp,rms_value];

    mav_value = mean(abs(channel1));
    temp=[temp,mav_value];
    mav_value = mean(abs(channel2));
    temp=[temp,mav_value];

    var_value = var(channel1);
    temp=[temp,var_value];
    var_value = var(channel2);
    temp=[temp,var_value];

    zc_value = sum(abs(diff(sign(channel1)))) / (length(channel1) - 1);
    temp=[temp,zc_value];
    zc_value = sum(abs(diff(sign(channel2)))) / (length(channel2) - 1);
    temp=[temp,zc_value];

    ssc_value = sum(abs(diff(sign(diff(channel1))))) / (length(channel1) - 2);
    temp=[temp,ssc_value];
    ssc_value = sum(abs(diff(sign(diff(channel2))))) / (length(channel2) - 2);
    temp=[temp,ssc_value];

    % 频域特征
    fft_result1 = fft(channel1);
    fft_result2 = fft(channel2);

    am_value = mean(abs(fft_result1));
    temp=[temp,am_value];
    am_value = mean(abs(fft_result2));
    temp=[temp,am_value];

    % 计算幅度谱  
    amp_spec = abs(fft_result1);  
    % 归一化幅度谱  
    amp_spec = amp_spec / sum(amp_spec);  
    % 计算质心  
    centroid = sum(amp_spec .* fft_result1);  
    % 计算质心频率
    Fs=250;
    centroid_freq = centroid * (Fs / 2);
    cf_value = centroid_freq;
    temp=[temp,cf_value];

    % 计算幅度谱  
    amp_spec = abs(fft_result2);  
    % 归一化幅度谱  
    amp_spec = amp_spec / sum(amp_spec);  
    % 计算质心  
    centroid = sum(amp_spec .* fft_result2);  
    % 计算质心频率
    Fs=250;
    centroid_freq = centroid * (Fs / 2);
    cf_value = centroid_freq;
    temp=[temp,cf_value];

    fvar_value = var(abs(fft_result1));
    temp=[temp,fvar_value];
    fvar_value = var(abs(fft_result2));
    temp=[temp,fvar_value];

    mdf_value = meanfreq(channel1);
    temp=[temp,mdf_value];
    mdf_value = meanfreq(channel2);
    temp=[temp,mdf_value];

    features_data((i+1)/2,:) = temp;
end

end