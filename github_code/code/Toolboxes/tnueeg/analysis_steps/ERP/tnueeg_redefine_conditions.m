<<<<<<< HEAD
function D = tnueeg_redefine_conditions( D, condlist)
=======
function D = tnueeg_redefine_conditions( D, condlist,id)
>>>>>>> 765825a99c36aa1a835988f19eff315581169a09
%TNUEEG_REDEFINE_CONDITIONS Updates the condition list before averaging
%   IN:     D           - preprocessed data set
%           condlist    - list with new condition names
%   OUT:    D           - data set with new conditions

if isempty(condlist)
    % do nothing, i.e., keep conditions in D as they are
else
    nTrials = numel(condlist);
    if numel(D.conditions) ~= nTrials
<<<<<<< HEAD
        error(['Unequal number of trials for subject ']);
=======
        error(['Unequal number of trials for subject ' id]);
>>>>>>> 765825a99c36aa1a835988f19eff315581169a09
    end
    D = conditions(D, 1: nTrials, condlist);
end

disp(['Redefined ' num2str(numel(D.conditions)) ' trials in current data set.']);

end

