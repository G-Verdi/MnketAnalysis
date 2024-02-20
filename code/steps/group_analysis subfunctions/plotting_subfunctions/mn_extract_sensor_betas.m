function betaVal = mn_extract_sensor_betas(imgFile,peakCoord)

% load in image and extract data
V = spm_vol(imgFile);
imgData = spm_read_vols(V);

% Convert the subscript indices (3D coordinates) to a linear index
linearIndex = sub2ind(size(imgData), peakCoord(1), peakCoord(2), peakCoord(3));

% Retrieve the value from imgData using the calculated linear index
linearIndex=fix(linearIndex);
betaVal = imgData(linearIndex);