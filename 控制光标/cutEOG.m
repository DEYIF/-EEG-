%cut_data是符合条件的裁剪数据，time为此片段在eeg上的位置
%如果没有符合条件的数据，time返回[-1,-1];cut_data返回[-1,-1]
function [cut_data, time] = cutEOG(eeg, start, frame_T, frame_move, frame_length, frame_energy)
   
    eog=eeg;
   
    % 每次裁剪需要移动的距离
    samples_per_frame_move = frame_move ;
    % 每个裁剪片段的距离（长度）
    samples_per_frame = frame_length;
    % 根据频率计算每秒裁剪的次数
    frames_per_second = 1 / frame_T;

    % 初始化裁剪数据和时间坐标
    cut_data = [];
    time = zeros(1,2);
    % 初始化当前位置
    current_pos = start;
    
    % 进行裁剪
    while true
        
        % 根据当前位置获取裁剪片段的起始和结束位置
        frame_start = current_pos;
        frame_end = frame_start + samples_per_frame - 1;
        
        if frame_end > size(eog, 1)
            % 当 frame_end 超过 eeg 数据总样本数时，终止循环
            cut_data=[-1,-1];
            time(1,1)=-1;
            time(1,2)=-1;
            break;
        end
        
        %将数据归一化
        % 计算每一列的最小值和最大值
        min_val = min(eog(frame_start:frame_end, :));
        max_val = max(eog(frame_start:frame_end, :));

        % 计算每一列的范围
        range = max_val - min_val;

        % 对每一列进行归一化
        normalized_data = (eog(frame_start:frame_end, :) - min_val) ./ range;
        
        % 计算当前裁剪片段的能量
        frame_energy_values = sum(abs(normalized_data(:,:) ).^2) / samples_per_frame;
        
        % 判断当前裁剪片段的每一列能量是否满足阈值
        if frame_energy_values(1) >= frame_energy && frame_energy_values(2) >= frame_energy
           cut_data =normalized_data;
           time(1,1)=frame_start;
           time(1,2)=frame_end;
           disp('裁剪');
           break;
        end

        % 移动到下一个裁剪位置
        current_pos = current_pos + samples_per_frame_move;

    end
    
end