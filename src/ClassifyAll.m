function ClassifyAll(path)

    filesPath = sprintf('%s\\*.mat', path);
    files = dir(filesPath);
    filesSize = size(files, 1);

    t = cputime();
    index = 0;

    for file = files'
        [~, baseFileNameNoExt, ~] = fileparts(file.name);
        baseFileNameNoExt = baseFileNameNoExt(1:end-1);
        fprintf('%s (%d \\ %d)\n', baseFileNameNoExt, index, filesSize - 1);
        filePath = sprintf('%s\\%s', path, baseFileNameNoExt);
        Classification(filePath);

        index = index + 1;
    end

    runningTime = cputime() - t;
    fprintf('Average time per record: %f\n', runningTime / filesSize);
    fprintf('Running time: %f\n', cputime() - t);
end