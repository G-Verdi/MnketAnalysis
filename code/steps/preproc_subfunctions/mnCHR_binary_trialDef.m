function [] = mnCHR_binary_trialDef(D,details)
%MNCHR_MMNAD_CONDITIONS Specifies trial type for each tone in a sequence
%based on duration deviant defined by values
%   IN:     D             - data structure
%   OUT:    conditions    - a cell array of condition labels of length nTones

% Get data structure and access values (S1, S2)

D = struct(D);

% First trial in D sometimes strange
% Trial1 = size(D.trials(1).events);
% Trial2 = size(D.trials(2).events);

% if ~isequaln(Trial1, Trial2)
%     if Trial1(2) == 2
%         D.trials(1).events(1) = [];
%     else
%         D.trials(1).events(2) = [];
%         D.trials(1).events(1) = [];
%     end
% end

x=length(D.trials);
tones = zeros(1,x);

for i = 1: x
    tones(i)=D.trials(i).events.value;
end

tones=tones.';
save(details.tonesroot, 'tones');
    
end