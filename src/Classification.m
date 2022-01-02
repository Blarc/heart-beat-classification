function [] = Classification(record, sampling_time)

    function [fsig] = HPFilter(sig, Fc, T)

        c1 = 1/(1+tan(Fc*pi*T));
        c2 = (1-tan(Fc*pi*T))/(1+tan(Fc*pi*T));

        sigLen = length(sig);
        fsig = zeros(1,sigLen);

        fsig(1) = c1*sig(1);
        for i=2:sigLen
            fsig(i)=c2*fsig(i-1)+c1*(sig(i)-sig(i-1));
        end
    end

    function [part_1, part_2] = classifyD1(i1, i2, a1, a2, l)
        s1 = size(i1, 2);
        part_1 = sum(abs(a1(1:s1) - i1)) / l;
        part_2 = sum(abs(a2(1:s1) - i2)) / l;
    end

    function [part_1, part_2] = classifyD2(i1, i2, a1, a2, l)
        s1 = size(i1, 2);
        part_1 = sqrt(sum(pow2(a1(1:s1) - i1)) / l);
        part_2 = sqrt(sum(pow2(a2(1:s1) - i2)) / l);
    end

    function [part_1, part_2] = classifyMax(i1, i2, a1, a2, l)
        s1 = size(i1, 2);
        part_1 = max(abs(a1(1:s1) - i1));
        part_2 = max(abs(a2(1:s1) - i2));
    end

    function [d1] = classifyD3(i1, i2, a1, a2, l)
        s1 = size(i1, 2);
        mean_i1 = mean(i1);
        mean_a1 = mean(a1);

        S_i1 = sum(pow2(i1 - mean_i1));
        S_a1 = sum(pow2(a1(1:s1) - mean_a1));

        r1 = (1 / sqrt(dot(S_i1, S_a1))) * sum(dot((i1 - mean_i1), (a1(1:s1) - mean_a1)));

        d1 = 1;
        if (r1 > 0)
            d1 = 1 - r;
        end
    end

    window_left = 14; % max 14
    window_right = 24; % max 24

    data_file = strcat(record, 'm.mat');
    fatr_file = strcat(record, '-fatr.txt');

    avg_N_file = strcat(record, sprintf('-avg-N-%d.txt', sampling_time));
    result_file = strcat(record, '.cls');

    dir_n = dir(avg_N_file);
    if (dir_n.bytes == 0)
        fprintf("Average signal does not exist!\n");
        return
    end

    avg_N = textread(avg_N_file);
    avg_N_1 = avg_N(15 - window_left: 15 + window_right, 2).';
    avg_N_2 = avg_N(15 - window_left: 15 + window_right, 3).';

    avg_length_N = size(avg_N_1, 2);

%    plot(avg_N_1);
%    hold on;

    data = load(data_file);
    data_1 = HPFilter(data.val(1, :), 2, 1/360) / 200;
    data_2 = HPFilter(data.val(2, :), 2, 1/360) / 200;
    data_length = size(data_1, 2);

    count = 0;
    fid = fopen(fatr_file);
    fid_result = fopen(result_file, "wt");

    while (~feof(fid))
        count = count + 1;
        line = fgetl(fid);
        z = textscan(line, '%s %s %d %s %d %d %d');
        fidicial_point = z{3};
        true_type = z{4};
        if (isempty(fidicial_point))
            z = textscan(line, '%s %d %s %d %d %d');
            fidicial_point = z{2};
            true_type = z{3};
        end

        from = max(1, fidicial_point - window_left);
        to = min(fidicial_point + window_right, data_length);
        input_1 = data_1(from:to);
        input_2 = data_2(from:to);

        [max_1, max_2] = classifyMax(input_1, input_2, avg_N_1, avg_N_2, avg_length_N);
        [d1_1, d1_2] = classifyD1(input_1, input_2, avg_N_1, avg_N_2, avg_length_N);

        if (max_1 < 1.0 && max_2 < 1.0 && d1_1 < 0.9)
            fprintf(fid_result, '0:00:00.00 %d N 0 0 0\n', fidicial_point);
        else
            fprintf(fid_result, '0:00:00.00 %d V 0 0 0\n', fidicial_point);
        end
    end

    % close the files
    fclose(fid);
    fclose(fid_result);
end

