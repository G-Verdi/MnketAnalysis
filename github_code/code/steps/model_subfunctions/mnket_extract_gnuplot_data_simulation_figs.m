function mnket_extract_gnuplot_data_simulation_figs(sim, design, savePath)

inp = sim.u;
inpo = sim.u_orig;
nTrials = length(inpo);
npt = 50;

% beliefs
bel.volatility = [NaN; sim.traj.mu(:, 3, 1, 1)];
bel.repetition = [NaN; sim.traj.muhat(:, 1, 1, 1)];
bel.transition = [NaN; sim.traj.muhat(:, 1, 3, 1)];
bel.tones = inpo;

% predition errors as regressors
reg.epsilon2 = design.epsilon2;
reg.epsilon2 = [NaN; reg.epsilon2];
reg.epsilon3 = design.epsilon3;
reg.epsilon3 = [NaN; reg.epsilon3];

% prediction errors detailed
pes.early.epsilon2 = reg.epsilon2(1: npt);
pes.early.epsilon3 = reg.epsilon3(1: npt);
pes.late.epsilon2 = reg.epsilon2(nTrials-npt+1: end);
pes.late.epsilon3 = reg.epsilon3(nTrials-npt+1: end);


%% write data into textfiles
cd(savePath);

fileID = fopen('data_beliefs.txt', 'w');
fprintf(fileID, '%i %6.4f %6.4f %6.4f %i\n', ...
    [1: nTrials; ...
    bel.volatility'; ...
    bel.repetition'; ...
    bel.transition'; ...
    bel.tones']);
fclose(fileID);

fileID = fopen('data_pes_all.txt', 'w');
fprintf(fileID, '%i %6.4f %6.4f\n', ...
    [1: nTrials; ...
    reg.epsilon3'; ...
    reg.epsilon2']);
fclose(fileID);

fileID = fopen('data_pes_detail.txt', 'w');
fprintf(fileID, '%i %6.4f %6.4f %i %i %6.4f %6.4f %i\n', ...
    [1: npt; ...
    pes.early.epsilon3'; ...
    pes.early.epsilon2'; ...
    inpo(1: npt)'; ...
    nTrials-npt+1: nTrials; ...
    pes.late.epsilon3'; ...
    pes.late.epsilon2'; ...
    inpo((end-npt+1): end)']);
fclose(fileID);

end

%%
%{
fileID = fopen('tones_all.txt', 'w');
fprintf(fileID, '%i %i\n', ...
    [1: nTrials; ...
    inpo';]);
fclose(fileID);

fileID = fopen('tones_early.txt', 'w');
fprintf(fileID, '%i %i\n', ...
    [1: npt; ...
    inpo(1:npt)';]);
fclose(fileID);

fileID = fopen('tones_late.txt', 'w');
fprintf(fileID, '%i %i\n', ...
    [nTrials-npt+1: nTrials; ...
    inpo((end-npt+1): end)';]);
fclose(fileID);


fileID = fopen('pes_all.txt', 'w');
fprintf(fileID, '%6.4f %6.4f\n', ...
    [reg.epsilon2; ...
    reg.epsilon3]);
fclose(fileID);

fileID = fopen('pes_early.txt', 'w');
fprintf(fileID, '%i %6.4f %6.4f\n', ...
    [1: npt; ...
    pes.early.epsilon2'; ...
    pes.early.epsilon3']);
fclose(fileID);

fileID = fopen('pes_late.txt', 'w');
fprintf(fileID, '%i %6.4f %6.4f\n', ...
    [nTrials-npt+1: nTrials; ...
    pes.late.epsilon2'; ...
    pes.late.epsilon3']);
fclose(fileID);
%}