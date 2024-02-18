function fileMap = remove_nans_from_nii(fileMap)
% remove nans from nifti file and copy it to a new file <oldName>NoNan.nii
% e.g. useful for displaying with interpolation
V = spm_vol(fileMap);
X = spm_read_vols(V);
X(isnan(X(:)))= 0;
V.fname = regexprep(V.fname, '\.nii', 'NoNaN\.nii');
spm_write_vol(V, X);
fileMap = regexprep(fileMap, '\.nii', 'NoNaN\.nii');

end
