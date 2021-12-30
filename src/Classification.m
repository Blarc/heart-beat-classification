function [] = Classification(record)

    function [score] = getScoreD1(i1, i2, a1, a2, l)
        part_1 = sum(abs(a1 - i1)) / l;
        part_2 = sum(abs(a2 - i2)) / l;
        score = (part_1 + part_2) / 2;
    end

    data_file = strcat(record, 'm.mat');
    fatr_file = strcat(record, '-fatr.txt');
    avg_N_file = strcat(record, '-avg-N.txt');
    avg_V_file = strcat(record, '-avg-V.txt');
    result_file = strcat(record, '.cls');

    dir_n = dir(avg_N_file);
    if (dir_n.bytes == 0)
        return
    end

    dir_v = dir(avg_V_file);
    if (dir_v.bytes == 0)
        return
    end
    
    avg_N = textread(avg_N_file);
    avg_N_1 = avg_N(:, 2).';
    avg_N_2 = avg_N(:, 3).';

    avg_V = textread(avg_V_file);
    avg_V_1 = avg_V(:, 2).';
    avg_V_2 = avg_V(:, 3).';

    avg_length_N = size(avg_N_1, 2);
    avg_length_V = size(avg_V_1, 2);
    
    data = load(data_file);
    data_1 = data.val(1, :) / 200;
    data_2 = data.val(2, :) / 200;
    data_length = size(data_1, 2);

    count = 0;
    fid = fopen(fatr_file);
    fid_result = fopen(result_file, "wt");

    while (~feof(fid))
        count = count + 1;
        line = fgetl(fid);
        z = textscan(line, '%s %s %d %s %d %d %d');
        fidicial_point = z{3};
        if (isempty(fidicial_point))
            z = textscan(line, '%s %d %s %d %d %d');
            fidicial_point = z{2};
        end
        
        from = max(1, fidicial_point - 14);
        to = min(fidicial_point + 24, data_length);
        input_1 = data_1(from:to);
        input_2 = data_2(from:to);

        part_N = getScoreD1(input_1, input_2, avg_N_1, avg_N_2, avg_length_N);        
        part_V = getScoreD1(input_1, input_2, avg_V_1, avg_V_2, avg_length_N);

        if (part_N < part_V)
            fprintf(fid_result, '0:00:00.00 %d N 0 0 0\n', fidicial_point);
        else
            fprintf(fid_result, '0:00:00.00 %d V 0 0 0\n', fidicial_point);
        end
    end
      
    % close the files
    fclose(fid);
    fclose(fid_result);
end

