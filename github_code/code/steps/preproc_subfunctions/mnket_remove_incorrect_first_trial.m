function D = mnket_remove_incorrect_first_trial(D)
%MNKET_REMOVE_INCORRECT_FIRST_TRIAL This function manages the special case of MMN_4458 in the
%ketamine condition, where an additional tone trigger event entered the EEG data, by removing that
%event from the data set before epoching. For details, see readme_special_case2_4458.
%   IN:     D   - EEG data set of MMN_4458 before epoching (continuous data)
%   OUT:    D   - EEG data set of MMN_4458 without additional first tone trigger event

% independent check that this is the correct file
h = history(D);
if ~strcmp(h(1).args.outfile, 'spmeeg_MMN_4458_1_ket')
    error(['Removing trial from an unexpected dataset. This should only apply'...
        ' to MMN_4458 in condition ketamine!'])
end

% does the first trigger event look as it should?
ev = events(D);
if ev(1).value ~= 3 || ~strcmp(ev(1).type, 'STATUS')
    error('First event does not look as it should, therefore, correction cannot be performed.');
end

% remove it from the list and update D
ev(1) = [];
D = events(D, 1, ev);

end