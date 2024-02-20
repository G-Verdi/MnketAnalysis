function [ shannon ] = mnket_calculate_shannon( mu1hat, tones )
%CALCULATE_SHANNON Calculates Shannon surprise from an agent's beliefs
% Input are the belief trajectories of an agent exposed to a sequence of
% tones, and this sequence. Output is trajectory of Shannon surprise per
% tone.

% agent learns about transition probabilities, therefore, she is only
% surprised starting at the second tone

shannon = NaN(length(tones)-1, 1);

for k = 2: length(tones)
    shannon(k-1) = -log2(squeeze(mu1hat(k-1, tones(k), tones(k-1))));
end

%shannon = shannon';

end