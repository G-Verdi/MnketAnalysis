% --- script for collecting all regressor trajectories MMN ---%

global OPTIONS
OPTIONS = mnket_set_global_options;

cd(OPTIONS.workdir);

OPTIONS.condition = 'placebo';

for idcell = OPTIONS.model.subjectIDs
    id = char(idcell);
    
    mnket_create_designs(id);
    disp(['created design files for subject ' id]);
end

cd(OPTIONS.workdir);

OPTIONS.condition = 'ketamine';

for idcell = OPTIONS.model.subjectIDs
    id = char(idcell);
    
    mnket_create_designs(id);
    disp(['created design files for subject ' id]);
end

cd(OPTIONS.workdir);
clear;

