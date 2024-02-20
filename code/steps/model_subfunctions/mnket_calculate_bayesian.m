function [ bayesian ] = mnket_calculate_bayesian( mu2, mu2hat, tones )
% computes bayesian surprise as |posterior - prior| of belief state mu2
% this is actually the same as 'model adjustment' and the
% precision-weighted prediction error epsilon on the current transition

bayesian = NaN(length(tones)-1, 1);

for k = 2: length(tones)
    bayesian(k-1) = abs((squeeze(mu2(k-1, tones(k), tones(k-1)))) - (squeeze(mu2hat(k-1, tones(k), tones(k-1)))));
end

%bayesian = bayesian';

end