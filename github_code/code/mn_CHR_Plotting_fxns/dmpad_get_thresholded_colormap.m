function myColorMap = dmpad_get_thresholded_colormap(upperThresholdBlack, upperThresholdColor, ...
    maxColor, nColorsTotal)
% creates one-color-based colormap (based on maxColor) with all-zeros 
% (black) for values below upperThresholdColor

if nargin < 4
    nColorsTotal = 64; %check via size(colormap,1) after starting checkreg
end

nColorsMap = floor((1-upperThresholdBlack/upperThresholdColor)*nColorsTotal);
nColorsBlack = nColorsTotal - nColorsMap;

myColorMap = zeros(nColorsMap,3);
for iColorChannel = 1:3
    myColorMap(:,iColorChannel) = linspace(maxColor(iColorChannel), 1, nColorsMap)';
end
myColorMap = [zeros(nColorsBlack,3);myColorMap];