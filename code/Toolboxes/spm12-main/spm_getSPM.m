function [SPM,xSPM] = spm_getSPM(varargin)
% Compute a specified and thresholded SPM/PPM following estimation
% FORMAT [SPM,xSPM] = spm_getSPM;
% Query SPM in interactive mode.
%
% FORMAT [SPM,xSPM] = spm_getSPM(xSPM);
% Query SPM in batch mode. See below for a description of fields that may
% be present in xSPM input. Values for missing fields will be queried
% interactively.
%
% xSPM      - structure containing SPM, distribution & filtering details
% .swd      - SPM working directory - directory containing current SPM.mat
% .title    - title for comparison (string)
% .Z        - minimum of Statistics {filtered on u and k}
% .n        - conjunction number <= number of contrasts
% .STAT     - distribution {Z, T, X, F or P}
% .df       - degrees of freedom [df{interest}, df{residual}]
% .STATstr  - description string
% .Ic       - indices of contrasts (in SPM.xCon)
% .Im       - indices of masking contrasts (in xCon)
% .pm       - p-value for masking (uncorrected)
% .Ex       - flag for exclusive or inclusive masking
% .u        - height threshold
% .k        - extent threshold {voxels}
% .XYZ      - location of voxels {voxel coords}
% .XYZmm    - location of voxels {mm}
% .S        - search Volume {voxels}
% .R        - search Volume {resels}
% .FWHM     - smoothness {voxels}
% .M        - voxels -> mm matrix
% .iM       - mm -> voxels matrix
% .VOX      - voxel dimensions {mm} - column vector
% .DIM      - image dimensions {voxels} - column vector
% .Vspm     - Mapped statistic image(s)
% .Ps       - uncorrected P values in searched volume (for voxel FDR)
% .Pp       - uncorrected P values of peaks (for peak FDR)
% .Pc       - uncorrected P values of cluster extents (for cluster FDR)
% .uc       - 0.05 critical thresholds for FWEp, FDRp, FWEc, FDRc
% .thresDesc - description of height threshold (string)
%
% Required fields of SPM
%
% xVol   - structure containing details of volume analysed
%
% xX     - Design Matrix structure
%        - (see spm_spm.m for structure)
%
% xCon   - Contrast definitions structure array
%        - (see also spm_FcUtil.m for structure, rules & handling)
% .name  - Contrast name
% .STAT  - Statistic indicator character ('T', 'F' or 'P')
% .c     - Contrast weights (column vector contrasts)
% .X0    - Reduced design matrix data (spans design space under Ho)
%          Stored as coordinates in the orthogonal basis of xX.X from spm_sp
%          Extract using X0 = spm_FcUtil('X0',...
% .iX0   - Indicates how contrast was specified:
%          If by columns for reduced design matrix then iX0 contains the
%          column indices. Otherwise, it's a string containing the
%          spm_FcUtil 'Set' action: Usually one of {'c','c+','X0'}
% .X1o   - Remaining design space data (X1o is orthogonal to X0)
%          Stored as coordinates in the orthogonal basis of xX.X from spm_sp
%          Extract using X1o = spm_FcUtil('X1o',...
% .eidf  - Effective interest degrees of freedom (numerator df)
%        - Or effect-size threshold for Posterior probability
% .Vcon  - Name of contrast (for 'T's) or ESS (for 'F's) image
% .Vspm  - Name of SPM image
%
% Evaluated fields in xSPM (input)
%
% xSPM      - structure containing SPM, distribution & filtering details
% .swd      - SPM working directory - directory containing current SPM.mat
% .title    - title for comparison (string)
% .Ic       - indices of contrasts (in SPM.xCon)
% .n        - conjunction number <= number of contrasts
% .Im       - indices of masking contrasts (in xCon)
% .pm       - p-value for masking (uncorrected)
% .Ex       - flag for exclusive or inclusive masking
% .u        - height threshold
% .k        - extent threshold {voxels}
% .thresDesc - description of height threshold (string)
%
% In addition, the xCon structure is updated. For newly evaluated
% contrasts, SPM images (spmT_????.{img,hdr}) are written, along with
% contrast (con_????.{img,hdr}) images for SPM{T}'s, or Extra
% Sum-of-Squares images (ess_????.{img,hdr}) for SPM{F}'s.
%
% The contrast images are the weighted sum of the parameter images,
% where the weights are the contrast weights, and are uniquely
% estimable since contrasts are checked for estimability by the
% contrast manager. These contrast images (for appropriate contrasts)
% are suitable summary images of an effect at this level, and can be
% used as input at a higher level when effecting a random effects
% analysis. (Note that the ess_????.{img,hdr} and
% SPM{T,F}_????.{img,hdr} images are not suitable input for a higher
% level analysis.)
%
%__________________________________________________________________________
%
% spm_getSPM prompts for an SPM and applies thresholds {u & k}
% to a point list of voxel values (specified with their locations {XYZ})
% This allows the SPM be displayed and characterized in terms of regionally
% significant effects by subsequent routines.
%
% For general linear model Y = XB + E with data Y, design matrix X,
% parameter vector B, and (independent) errors E, a contrast c'B of the
% parameters (with contrast weights c) is estimated by c'b, where b are
% the parameter estimates given by b=pinv(X)*Y.
%
% Either single contrasts can be examined or conjunctions of different
% contrasts. Contrasts are estimable linear combinations of the
% parameters, and are specified using the SPM contrast manager
% interface [spm_conman.m]. SPMs are generated for the null hypotheses
% that the contrast is zero (or zero vector in the case of
% F-contrasts). See the help for the contrast manager [spm_conman.m]
% for a further details on contrasts and contrast specification.
%
% A conjunction assesses the conjoint expression of multiple effects. The
% conjunction SPM is the minimum of the component SPMs defined by the
% multiple contrasts.  Inference on the minimum statistics can be
% performed in different ways.  Inference on the Conjunction Null (one or
% more of the effects null) is accomplished by assessing the minimum as
% if it were a single statistic; one rejects the conjunction null in
% favor of the alternative that k=nc, that the number of active effects k
% is equal to the number of contrasts nc.  No assumptions are needed on
% the dependence between the tests.
%
% Another approach is to make inference on the Global Null (all effects
% null).  Rejecting the Global Null of no (u=0) effects real implies an
% alternative that k>0, that one or more effects are real.   A third
% Intermediate approach, is to use a null hypothesis of no more than u
% effects are real.  Rejecting the intermediate null that k<=u implies an
% alternative that k>u, that more than u of the effects are real.
%
% The Global and Intermediate nulls use results for minimum fields which
% require the SPMs to be identically distributed and independent. Thus,
% all component SPMs must be either SPM{t}'s, or SPM{F}'s with the same
% degrees of freedom. Independence is roughly guaranteed for large
% degrees of freedom (and independent data) by ensuring that the
% contrasts are "orthogonal". Note that it is *not* the contrast weight
% vectors per se that are required to be orthogonal, but the subspaces of
% the data space implied by the null hypotheses defined by the contrasts
% (c'pinv(X)). Furthermore, this assumes that the errors are
% i.i.d. (i.e. the estimates are maximum likelihood or Gauss-Markov. This
% is the default in spm_spm).
%
% To ensure approximate independence of the component SPMs in the case of
% the global or intermediate null, non-orthogonal contrasts are serially
% orthogonalised in the order specified, possibly generating new
% contrasts, such that the second is orthogonal to the first, the third
% to the first two, and so on.  Note that significant inference on the
% global null only allows one to conclude that one or more of the effects
% are real.  Significant inference on the conjunction null allows one to
% conclude that all of the effects are real.
%
% Masking simply eliminates voxels from the current contrast if they
% do not survive an uncorrected p value (based on height) in one or
% more further contrasts.  No account is taken of this masking in the
% statistical inference pertaining to the masked contrast.
%
% The SPM is subject to thresholding on the basis of height (u) and the
% number of voxels comprising its clusters {k}. The height threshold is
% specified as above in terms of an [un]corrected p value or
% statistic.  Clusters can also be thresholded on the basis of their
% spatial extent. If you want to see all voxels simply enter 0.  In this
% instance the 'set-level' inference can be considered an 'omnibus test'
% based on the number of clusters that obtain.
%
% BAYESIAN INFERENCE AND PPMS - POSTERIOR PROBABILITY MAPS
%
% If conditional estimates are available (and your contrast is a T
% contrast) then you are asked whether the inference should be 'Bayesian'
% or 'classical' (using GRF).  If you choose Bayesian the contrasts are of
% conditional (i.e. MAP) estimators and the inference image is a
% posterior probability map (PPM).  PPMs encode the probability that the
% contrast exceeds a specified threshold.  This threshold is stored in
% the xCon.eidf.  Subsequent plotting and tables will use the conditional
% estimates and associated posterior or conditional probabilities.
%
% see spm_results_ui.m for further details of the SPM results section.
% see also spm_contrasts.m
%__________________________________________________________________________
% Copyright (C) 1999-2017 Wellcome Trust Centre for Neuroimaging

% Andrew Holmes, Karl Friston & Jean-Baptiste Poline
% $Id: spm_getSPM.m 7092 2017-06-05 15:08:49Z guillaume $


%-GUI setup
%--------------------------------------------------------------------------
spm('Pointer','Arrow')

%-Select SPM.mat & note SPM results directory
%--------------------------------------------------------------------------
if nargin
    xSPM = varargin{1};
end
try
    swd = xSPM.swd;
    sts = 1;
catch
    [spmmatfile, sts] = spm_select(1,'^SPM\.mat$','Select SPM.mat');
    swd = spm_file(spmmatfile,'fpath');
end
if ~sts, SPM = []; xSPM = []; return; end

%-Preliminaries...
%==========================================================================

%-Load SPM.mat
%--------------------------------------------------------------------------
try
    load(fullfile(swd,'SPM.mat'));
catch
    error(['Cannot read ' fullfile(swd,'SPM.mat')]);
end
SPM.swd = swd;


%-Change directory so that relative filenames are valid
%--------------------------------------------------------------------------
cd(SPM.swd);

%-Check the model has been estimated
%--------------------------------------------------------------------------
try
    SPM.xVol.S;
catch
    spm('alert*',{'This model has not been estimated.','',...
        fullfile(swd,'SPM.mat')}, mfilename, [], ~spm('CmdLine'));
    SPM = []; xSPM = [];
    return
end

xX   = SPM.xX;                      %-Design definition structure
XYZ  = SPM.xVol.XYZ;                %-XYZ coordinates
S    = SPM.xVol.S;                  %-search Volume {voxels}
R    = SPM.xVol.R;                  %-search Volume {resels}
M    = SPM.xVol.M(1:3,1:3);         %-voxels to mm matrix
VOX  = sqrt(diag(M'*M))';           %-voxel dimensions

%==========================================================================
% - C O N T R A S T S ,   S P M    C O M P U T A T I O N ,    M A S K I N G
%==========================================================================

%-Get contrasts
%--------------------------------------------------------------------------
try, xCon = SPM.xCon; catch, xCon = {}; end

try
    Ic        = xSPM.Ic;
catch
    [Ic,xCon] = spm_conman(SPM,'T&F',Inf,...
                           '    Select contrasts...',' for conjunction',1);
end
if isempty(xCon)
    % figure out whether new contrasts were defined, but not selected
    % do this by comparing length of SPM.xCon to xCon, remember added
    % indices to run spm_contrasts on them as well
    try
        noxCon = numel(SPM.xCon);
    catch
        noxCon = 0;
    end
    IcAdd = (noxCon+1):numel(xCon);
else
    IcAdd = [];
end

nc        = length(Ic);  % Number of contrasts

%-Allow user to extend the null hypothesis for conjunctions
%
% n: conjunction number
% u: Null hyp is k<=u effects real; Alt hyp is k>u effects real
%    (NB Here u is from Friston et al 2004 paper, not statistic thresh).
%                  u         n
% Conjunction Null nc-1      1     |    u = nc-n
% Intermediate     1..nc-2   nc-u  |    #effects under null <= u
% Global Null      0         nc    |    #effects under alt  > u,  >= u+1
%----------------------------------+---------------------------------------
if nc > 1
    try
        n = xSPM.n;
    catch
        if nc==2
            But = 'Conjunction|Global';      Val=[1 nc];
        else
            But = 'Conj''n|Intermed|Global'; Val=[1 NaN nc];
        end
        n = spm_input('Null hyp. to assess?','+1','b',But,Val,1);
        if isnan(n)
            if nc == 3,
                n = nc - 1;
            else
                n = nc - spm_input('Effects under null ','0','n1','1',nc-1);
            end
        end
    end
else
    n = 1;
end

%-Enforce orthogonality of multiple contrasts for conjunction
% (Orthogonality within subspace spanned by contrasts)
%--------------------------------------------------------------------------
if nc > 1 && n > 1 && ~spm_FcUtil('|_?',xCon(Ic), xX.xKXs)
    
    OrthWarn = 0;
    
    %-Successively orthogonalise
    %-NB: This loop is peculiarly controlled to account for the
    %     possibility that Ic may shrink if some contrasts disappear
    %     on orthogonalisation (i.e. if there are colinearities)
    %----------------------------------------------------------------------
    i = 1;
    while(i < nc), i = i + 1;
        
        %-Orthogonalise (subspace spanned by) contrast i w.r.t. previous
        %------------------------------------------------------------------
        oxCon = spm_FcUtil('|_',xCon(Ic(i)), xX.xKXs, xCon(Ic(1:i-1)));
        
        %-See if this orthogonalised contrast has already been entered
        % or is colinear with a previous one. Define a new contrast if
        % neither is the case.
        %------------------------------------------------------------------
        d     = spm_FcUtil('In',oxCon,xX.xKXs,xCon);
        
        if spm_FcUtil('0|[]',oxCon,xX.xKXs)
            
            %-Contrast was colinear with a previous one - drop it
            %--------------------------------------------------------------
            Ic(i) = [];
            i     = i - 1;
            
        elseif any(d)
            
            %-Contrast unchanged or already defined - note index
            %--------------------------------------------------------------
            Ic(i) = min(d);
            
        else
            
            %-Define orthogonalised contrast as new contrast
            %--------------------------------------------------------------
            OrthWarn   = OrthWarn + 1;
            conlst     = sprintf('%d,',Ic(1:i-1));
            oxCon.name = sprintf('%s (orth. w.r.t {%s})', xCon(Ic(i)).name,...
                                  conlst(1:end-1));
            xCon       = [xCon, oxCon];
            Ic(i)      = length(xCon);
        end
        
    end % while...
    
    if OrthWarn
        warning('SPM:ConChange','%d contrasts orthogonalized',OrthWarn)
    end
    
    SPM.xCon = xCon;
end % if nc>1...
SPM.xCon = xCon;

%-Apply masking
%--------------------------------------------------------------------------
try
    Mask = ~isempty(xSPM.Im) * (isnumeric(xSPM.Im) + 2*iscellstr(xSPM.Im));
catch
    % Mask = spm_input('mask with other contrast(s)','+1','y/n',[1,0],2);
    % Mask = spm_input('apply masking','+1','b','none|contrast|image',[0,1,2],1);
    Mask = spm_input('apply masking','+1','b','none|contrast|image|atlas',[0,1,2,3],1);
end
if Mask == 1
    
    %-Get contrasts for masking
    %----------------------------------------------------------------------
    try
        Im = xSPM.Im;
    catch
        [Im,xCon] = spm_conman(SPM,'T&F',-Inf,...
            'Select contrasts for masking...',' for masking',1);
    end
    
    %-Threshold for mask (uncorrected p-value)
    %----------------------------------------------------------------------
    try
        pm = xSPM.pm;
    catch
        pm = spm_input('uncorrected mask p-value','+1','r',0.05,1,[0,1]);
    end
    
    %-Inclusive or exclusive masking
    %----------------------------------------------------------------------
    try
        Ex = xSPM.Ex;
    catch
        Ex = spm_input('nature of mask','+1','b','inclusive|exclusive',[0,1],1);
    end
    
elseif Mask == 2
    
    %-Get mask images
    %----------------------------------------------------------------------
    try
        Im = xSPM.Im;
    catch
        [Im, sts] = spm_select([1 Inf],{'image','mesh'},'Select mask image(s)');
        if ~sts, Im = []; else Im = cellstr(Im); end
    end
    
    %-Inclusive or exclusive masking
    %----------------------------------------------------------------------
    try
        Ex = xSPM.Ex;
    catch
        Ex = spm_input('nature of mask','+1','b','inclusive|exclusive',[0,1],1);
    end
    
    pm = [];
    
elseif Mask == 3 % unused
    
    %-Get mask from atlas
    %----------------------------------------------------------------------
    try
        error('Im = xSPM.Im;');                  % interactive only
    catch
        VM       = spm_atlas('mask');            % get atlas mask
        VM.fname = spm_file(VM.fname,'unique');
        VM       = spm_write_vol(VM,VM.dat);     % write mask
        Im       = cellstr(VM.fname);
    end
    
    %-Inclusive or exclusive masking
    %----------------------------------------------------------------------
    try
        Ex = xSPM.Ex;
    catch
        Ex = spm_input('nature of mask','+1','b','inclusive|exclusive',[0,1],1);
    end
    
    pm = [];
    
else
    Im = [];
    pm = [];
    Ex = [];
end


%-Create/Get title string for comparison
%--------------------------------------------------------------------------
if nc == 1
    str  = xCon(Ic).name;
else
    str  = [sprintf('contrasts {%d',Ic(1)),sprintf(',%d',Ic(2:end)),'}'];
    if n == nc
        str = [str ' (global null)'];
    elseif n == 1
        str = [str ' (conj. null)'];
    else
        str = [str sprintf(' (Ha: k>=%d)',(nc-n)+1)];
    end
end
if Ex
    mstr = 'masked [excl.] by';
else
    mstr = 'masked [incl.] by';
end
if isnumeric(Im)
    if length(Im) == 1
        str = sprintf('%s (%s %s at p=%g)',str,mstr,xCon(Im).name,pm);
    elseif ~isempty(Im)
        str = [sprintf('%s (%s {%d',str,mstr,Im(1)),...
            sprintf(',%d',Im(2:end)),...
            sprintf('} at p=%g)',pm)];
    end
elseif iscellstr(Im) && numel(Im) > 0
    [pf,nf,ef] = spm_fileparts(Im{1});
    str  = sprintf('%s (%s %s',str,mstr,[nf ef]);
    for i=2:numel(Im)
        [pf,nf,ef] = spm_fileparts(Im{i});
        str =[str sprintf(', %s',[nf ef])];
    end
    str = [str ')'];
end
try
    titlestr = xSPM.title;
catch
    %titlestr = spm_input('title for comparison','+1','s',str);
    titlestr = '';
end
if isempty(titlestr), titlestr = str; end


%-Bayesian or classical Inference?
%==========================================================================
if isfield(SPM,'PPM')
    
    % Make sure SPM.PPM.xCon field exists
    %----------------------------------------------------------------------
    if ~isfield(SPM.PPM,'xCon')
        SPM.PPM.xCon = [];
    end
    
    % Set Bayesian con type - but only if empty
    %----------------------------------------------------------------------
    if length(SPM.PPM.xCon)<Ic || ~isfield(SPM.PPM.xCon(Ic), 'PSTAT') || isempty(SPM.PPM.xCon(Ic).PSTAT)
        SPM.PPM.xCon(Ic).PSTAT = xCon(Ic).STAT;
    end
    
    if all(strcmp([SPM.PPM.xCon(Ic).PSTAT],'T'))
        
        % Simple contrast
        %------------------------------------------------------------------
        str = 'Effect size threshold for PPM';
        
        if isfield(SPM.PPM,'VB') % 1st level Bayes
            
            % For VB - set default effect size 
            %--------------------------------------------------------------
            if exist('xSPM','var') && isfield(xSPM,'gamma') && ~isempty(xSPM.gamma)
                xCon(Ic).eidf = xSPM.gamma;
            else
                Gamma = 0.1;
                xCon(Ic).eidf = spm_input(str,'+1','e',sprintf('%0.2f',Gamma));
            end
            xCon(Ic).STAT='P';
            
        else % 2nd level Bayes
            %--------------------------------------------------------------
            if isempty(xCon(Ic).Vcon)
                % If this is first time contrast is specified then
                % ask user if it will be Bayesian or Classical
                if spm_input('Inference',1,'b',{'Bayesian','classical'},[1 0]);
                    xCon(Ic).STAT = 'P';
                end
            end
            % If Bayesian then get effect size threshold (Gamma) stored in xCon(Ic).eidf
            % The default is one conditional s.d. of the contrast
            %--------------------------------------------------------------
            if strcmp(xCon(Ic).STAT,'P')
                if exist('xSPM','var') && isfield(xSPM,'gamma') && ~isempty(xSPM.gamma)
                   xCon(Ic).eidf = xSPM.gamma;
                else 
                    Gamma         = full(sqrt(xCon(Ic).c'*SPM.PPM.Cb*xCon(Ic).c));
                    xCon(Ic).eidf = spm_input(str,'+1','e',sprintf('%0.2f',Gamma));
                end
            end
        end
    else
        if isempty(xCon(Ic).Vcon)
            % If this is first time contrast is specified then
            % ask user if it will be Bayesian or Classical
            %--------------------------------------------------------------
            if spm_input('Inference',1,'b',{'Bayesian','classical'},[1 0]);
                % Chi^2 statistic - 1st Level Bayes
                % Savage-Dickey - 2nd Level Bayes
                xCon(Ic).eidf = 0; % temporarily
                xCon(Ic).STAT='P';
            end
        end
    end
end


%-Compute & store contrast parameters, contrast/ESS images, & SPM images
%==========================================================================
SPM.xCon = xCon;
if isnumeric(Im)
    SPM  = spm_contrasts(SPM, unique([Ic, Im, IcAdd]));
else
    SPM  = spm_contrasts(SPM, unique([Ic, IcAdd]));
end
xCon     = SPM.xCon;
STAT     = xCon(Ic(1)).STAT;
VspmSv   = cat(1,xCon(Ic).Vspm);

%-Check conjunctions - Must be same STAT w/ same df
%--------------------------------------------------------------------------
if (nc > 1) && (any(diff(double(cat(1,xCon(Ic).STAT)))) || ...
                any(abs(diff(cat(1,xCon(Ic).eidf))) > 1))
    error('illegal conjunction: can only conjoin SPMs of same STAT & df');
end


%-Degrees of Freedom and STAT string describing marginal distribution
%--------------------------------------------------------------------------
df     = [xCon(Ic(1)).eidf xX.erdf];
if nc > 1
    if n > 1
        str = sprintf('^{%d \\{Ha:k\\geq%d\\}}',nc,(nc-n)+1);
    else
        str = sprintf('^{%d \\{Ha:k=%d\\}}',nc,(nc-n)+1);
    end
else
    str = '';
end

switch STAT
    case 'T'
        STATstr = sprintf('%s%s_{%.0f}','T',str,df(2));
    case 'F'
        STATstr = sprintf('%s%s_{%.0f,%.0f}','F',str,df(1),df(2));
    case 'P'
        if strcmp(SPM.PPM.xCon(Ic).PSTAT,'T')
            STATstr = sprintf('%s^{%0.2f}','PPM',df(1));
        else
            STATstr='PPM';
        end
end


%-Compute (unfiltered) SPM pointlist for masked conjunction requested
%==========================================================================
fprintf('\t%-32s: %30s','SPM computation','...initialising')            %-#


%-Compute conjunction as minimum of SPMs
%--------------------------------------------------------------------------
Z     = Inf;
for i = Ic
    Z = min(Z,spm_data_read(xCon(i).Vspm,'xyz',XYZ));
end


%-Copy of Z and XYZ before masking, for later use with FDR
%--------------------------------------------------------------------------
XYZum = XYZ;
Zum   = Z;

%-Compute mask and eliminate masked voxels
%--------------------------------------------------------------------------
for i = 1:numel(Im)
    
    fprintf('%s%30s',repmat(sprintf('\b'),1,30),'...masking')           %-#
    if isnumeric(Im)
        Mask = spm_data_read(xCon(Im(i)).Vspm,'xyz',XYZ);
        um   = spm_u(pm,[xCon(Im(i)).eidf,xX.erdf],xCon(Im(i)).STAT);
        if Ex
            Q = Mask <= um;
        else
            Q = Mask >  um;
        end
    else
        v = spm_data_hdr_read(Im{i});
        Mask = spm_data_read(v,'xyz',v.mat\SPM.xVol.M*[XYZ; ones(1,size(XYZ,2))]);
        Q = Mask ~= 0 & ~isnan(Mask);
        if Ex, Q = ~Q; end
    end
    XYZ   = XYZ(:,Q);
    Z     = Z(Q);
    if isempty(Q)
        fprintf('\n')                                                   %-#
        sw = warning('off','backtrace');
        warning('SPM:NoVoxels','No voxels survive masking at p=%4.2f',pm);
        warning(sw);
        break
    end
end


%==========================================================================
% - H E I G H T   &   E X T E N T   T H R E S H O L D S
%==========================================================================

u   = -Inf;        % height threshold
k   = 0;           % extent threshold {voxels}

%-Get FDR mode
%--------------------------------------------------------------------------
try
    topoFDR = spm_get_defaults('stats.topoFDR');
catch
    topoFDR = true;
end

if  spm_mesh_detect(xCon(Ic(1)).Vspm)
    G = export(gifti(SPM.xVol.G),'patch');
end

%-Height threshold - classical inference
%--------------------------------------------------------------------------
if STAT ~= 'P'
    
    %-Get height threshold
    %----------------------------------------------------------------------
    fprintf('%s%30s',repmat(sprintf('\b'),1,30),'...height threshold')  %-#
    try
        thresDesc = xSPM.thresDesc;
    catch
        if topoFDR
            str = 'FWE|none';
        else
            str = 'FWE|FDR|none';
        end
        thresDesc = spm_input('p value adjustment to control','+1','b',str,[],1);
    end
    
    switch thresDesc
        
        case 'FWE' % Family-wise false positive rate
            %--------------------------------------------------------------
            try
                u = xSPM.u;
            catch
                u = spm_input('p value (FWE)','+0','r',0.05,1,[0,1]);
            end
            thresDesc = ['p<' num2str(u) ' (' thresDesc ')'];
            u = spm_uc(u,df,STAT,R,n,S);
            
            
        case 'FDR' % False discovery rate
            %--------------------------------------------------------------
            if topoFDR
                fprintf('\n');                                          %-#
                error('Change defaults.stats.topoFDR to use voxel FDR');
            end
            try
                u = xSPM.u;
            catch
                u = spm_input('p value (FDR)','+0','r',0.05,1,[0,1]);
            end
            thresDesc = ['p<' num2str(u) ' (' thresDesc ')'];
            u = spm_uc_FDR(u,df,STAT,n,VspmSv,0);
            
        case 'none'  % No adjustment: p for conjunctions is p of the conjunction SPM
            %--------------------------------------------------------------
            try
                u = xSPM.u;
            catch
                u = spm_input(['threshold {',STAT,' or p value}'],'+0','r',0.001,1);
            end
            if u <= 1
                thresDesc = ['p<' num2str(u) ' (unc.)'];
                u = spm_u(u^(1/n),df,STAT);
            else
                thresDesc = [STAT '=' num2str(u) ];
            end
            
            
        otherwise
            %--------------------------------------------------------------
            fprintf('\n');                                              %-#
            error('Unknown control method "%s".',thresDesc);
            
    end % switch thresDesc
    
    %-Compute p-values for topological and voxel-wise FDR (all search voxels)
    %----------------------------------------------------------------------
    if ~topoFDR
        %-Voxel-wise FDR
        %------------------------------------------------------------------
        fprintf('%s%30s',repmat(sprintf('\b'),1,30),'...for voxelFDR')  %-#
        Ps = spm_z2p(Zum,df,STAT,n);
        up = spm_uc_FDR(0.05,df,STAT,n,sort(Ps(:)));
        Pp = [];
    else
        %-Peak FDR
        %------------------------------------------------------------------
        if ~spm_mesh_detect(xCon(Ic(1)).Vspm)
            [up,Pp] = spm_uc_peakFDR(0.05,df,STAT,R,n,Zum,XYZum,u);
        else
            [up,Pp] = spm_uc_peakFDR(0.05,df,STAT,R,n,Zum,XYZum,u,G);
        end
     end
    
    %-Cluster FDR
    %----------------------------------------------------------------------
    if n == 1 %% && STAT == 'T'
        if ~spm_mesh_detect(xCon(Ic(1)).Vspm)
            V2R        = 1/prod(SPM.xVol.FWHM(SPM.xVol.DIM > 1));
            [uc,Pc,ue] = spm_uc_clusterFDR(0.05,df,STAT,R,n,Zum,XYZum,V2R,u);
        else
            V2R        = 1/prod(SPM.xVol.FWHM);
            [uc,Pc,ue] = spm_uc_clusterFDR(0.05,df,STAT,R,n,Zum,XYZum,V2R,u,G);
        end
    else
        uc  = NaN;
        ue  = NaN;
        Pc  = [];
    end
    
    if ~topoFDR
        uc  = NaN;
        Pc  = [];
    end
    
    %-Peak FWE
    %----------------------------------------------------------------------
    uu      = spm_uc(0.05,df,STAT,R,n,S);
    
    
%-Height threshold - Bayesian inference
%--------------------------------------------------------------------------
elseif STAT == 'P'
    try
        u = xSPM.u;
    catch
        u_default = 10;
        str       = 'Log Odds Threshold for PPM';
        u         = spm_input(str,'+0','r',u_default,1);
    end
    thresDesc = ['Log Odds > '  num2str(u)];
    
end % (if STAT)

%-Calculate height threshold filtering
%--------------------------------------------------------------------------
if spm_mesh_detect(xCon(Ic(1)).Vspm), str = 'vertices'; else str = 'voxels'; end
Q      = find(Z > u);

%-Apply height threshold
%--------------------------------------------------------------------------
Z      = Z(:,Q);
XYZ    = XYZ(:,Q);
if isempty(Q)
    fprintf('\n');                                                      %-#
    sw = warning('off','backtrace');
    warning('SPM:NoVoxels','No %s survive height threshold at u=%0.2g',str,u);
    warning(sw);
end


%-Extent threshold
%--------------------------------------------------------------------------
if ~isempty(XYZ)
    
    fprintf('%s%30s',repmat(sprintf('\b'),1,30),'...extent threshold'); %-#
    
    %-Get extent threshold [default = 0]
    %----------------------------------------------------------------------
    try
        k = xSPM.k;
    catch
        k = spm_input(['& extent threshold {' str '}'],'+1','r',0,1,[0,Inf]);
    end
    
    %-Calculate extent threshold filtering
    %----------------------------------------------------------------------
    if  ~spm_mesh_detect(xCon(Ic(1)).Vspm)
        A = spm_clusters(XYZ);
    else
        T = false(SPM.xVol.DIM');
        T(XYZ(1,:)) = true;
        A = spm_mesh_clusters(G,T)';
        A = A(XYZ(1,:));
    end
    Q     = [];
    for i = 1:max(A)
        j = find(A == i);
        if length(j) >= k, Q = [Q j]; end
    end
    
    % ...eliminate voxels
    %----------------------------------------------------------------------
    Z     = Z(:,Q);
    XYZ   = XYZ(:,Q);
    if isempty(Q)
        fprintf('\n');                                                  %-#
        sw = warning('off','backtrace');
        warning('SPM:NoVoxels','No %s survive extent threshold at k=%0.2g',str,k);
        warning(sw);
    end
    
else
    try
        k = xSPM.k;
    catch
        k = 0;
    end
    
end % (if ~isempty(XYZ))

%==========================================================================
% - E N D
%==========================================================================
fprintf('%s%30s\n',repmat(sprintf('\b'),1,30),'...done')                %-#
spm('Pointer','Arrow')

%-Assemble output structures of unfiltered data
%==========================================================================
xSPM   = struct( ...
            'swd',      swd,...
            'title',    titlestr,...
            'Z',        Z,...
            'n',        n,...
            'STAT',     STAT,...
            'df',       df,...
            'STATstr',  STATstr,...
            'Ic',       Ic,...
            'Im',       {Im},...
            'pm',       pm,...
            'Ex',       Ex,...
            'u',        u,...
            'k',        k,...
            'XYZ',      XYZ,...
            'XYZmm',    SPM.xVol.M(1:3,:)*[XYZ; ones(1,size(XYZ,2))],...
            'S',        SPM.xVol.S,...
            'R',        SPM.xVol.R,...
            'FWHM',     SPM.xVol.FWHM,...
            'M',        SPM.xVol.M,...
            'iM',       SPM.xVol.iM,...
            'DIM',      SPM.xVol.DIM,...
            'VOX',      VOX,...
            'Vspm',     VspmSv,...
            'thresDesc',thresDesc);

%-RESELS per voxel (density) if it exists
%--------------------------------------------------------------------------
try, xSPM.VRpv = SPM.xVol.VRpv; end
try
    xSPM.units = SPM.xVol.units;
catch
    try, xSPM.units = varargin{1}.units; end
end

%-Topology for surface-based inference
%--------------------------------------------------------------------------
if spm_mesh_detect(xCon(Ic(1)).Vspm)
    xSPM.G     = G;
    xSPM.XYZmm = xSPM.G.vertices(xSPM.XYZ(1,:),:)';
end

%-p-values for topological and voxel-wise FDR
%--------------------------------------------------------------------------
try, xSPM.Ps   = Ps;             end  % voxel   FDR
try, xSPM.Pp   = Pp;             end  % peak    FDR
try, xSPM.Pc   = Pc;             end  % cluster FDR

%-0.05 critical thresholds for FWEp, FDRp, FWEc, FDRc
%--------------------------------------------------------------------------
try, xSPM.uc   = [uu up ue uc];  end
