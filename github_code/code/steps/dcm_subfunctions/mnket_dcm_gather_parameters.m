function [pla_params_muhat1,pla_params_muhat3,pla_params_sahat,ket_params_muhat1,ket_params_muhat3,ket_params_sahat]=mnket_dcm_gather_parameters(options)
% DCM_GATHER Runs mnket_dcm for each subject and gathers 5 B matrix
% paramters from each subject into one structure
% IN: options               -the struct that holds all analysis options
% OUT:                      -19X6 matrix
% BY: GABRIELLE A

% Setup empty matrices for each regressor in each condition 
% pla_params_epsi2 = zeros(19,6);
% pla_params_epsi3 = zeros(19,6);
% ket_params_epsi2 = zeros(19,6);
% ket_params_epsi3 = zeros(19,6);

pla_params_muhat1 = zeros(19,6);
pla_params_muhat3 = zeros(19,6);
pla_params_sahat = zeros(19,6);
ket_params_muhat1 = zeros(19,6);
ket_params_muhat3 = zeros(19,6);
ket_params_sahat = zeros(19,6);

%Establish count for subject list
rvec = [];
count=1;    

    
for idCell = options.subjects.all
    id = char(idCell);
    
% paths and files
    [~, paths] = mnket_subjects(options);
    
%set output file
    if ~exist(paths.dcmroot,'dir')
        mkdir(paths.dcmroot)
    end

%Record what we're doing
    diary(paths.logfile);
    mnket_display_analysis_step_header('Reporting DCM Stats', ...
        'all', options.stats);
    
    cd 
%Gather parameters    
    for optionsCell = {'placebo'}
    	options.condition = char(optionsCell);
		options.erp.type = 'lowhighMuhat1';

    	[BmatrixParameters]= mnket_dcm(id,options);
		rvec= [BmatrixParameters(3),BmatrixParameters(9),BmatrixParameters(11),BmatrixParameters(17),BmatrixParameters(20),BmatrixParameters(24)];
    	pla_params_muhat1(count,:)= rvec;

    	options.erp.type = 'lowhighMuhat3';

    	[BmatrixParameters]= mnket_dcm(id,options);
		rvec= [BmatrixParameters(3),BmatrixParameters(9),BmatrixParameters(11),BmatrixParameters(17),BmatrixParameters(20),BmatrixParameters(24)];
    	pla_params_muhat3(count,:)= rvec;
        
        
        options.erp.type = 'lowhighSahat';

    	[BmatrixParameters]= mnket_dcm(id,options);
		rvec= [BmatrixParameters(3),BmatrixParameters(9),BmatrixParameters(11),BmatrixParameters(17),BmatrixParameters(20),BmatrixParameters(24)];
    	pla_params_sahat(count,:)= rvec;
        
    end

 	for optionsCell = {'ketamine'}
    	options.condition = char(optionsCell);

    	options.erp.type = 'lowhighMuhat1';

    	[BmatrixParameters]= mnket_dcm(id,options);
		rvec= [BmatrixParameters(3),BmatrixParameters(9),BmatrixParameters(11),BmatrixParameters(17),BmatrixParameters(20),BmatrixParameters(24)];
    	ket_params_muhat1(count,:)= rvec;
       

    	options.erp.type = 'lowhighMuhat3';

    	[BmatrixParameters]= mnket_dcm(id,options);
		rvec= [BmatrixParameters(3),BmatrixParameters(9),BmatrixParameters(11),BmatrixParameters(17),BmatrixParameters(20),BmatrixParameters(24)];
    	ket_params_muhat3(count,:)= rvec;
        
        
        options.erp.type = 'lowhighSahat';

    	[BmatrixParameters]= mnket_dcm(id,options);
		rvec= [BmatrixParameters(3),BmatrixParameters(9),BmatrixParameters(11),BmatrixParameters(17),BmatrixParameters(20),BmatrixParameters(24)];
    	ket_params_sahat(count,:)= rvec;
    
    end
    
    count=count+1;   
    
    
diary OFF

%Save to dcm folder 
cd 'C:\Users\Gabrielle\Desktop\Cognemo\mnket\ketdata\prj\test_mnket\dcm'
save('pla_params_muhat1')  		
save('pla_params_muhat3')
save('pla_params_sahat')
save('ket_params_muhat1')
save('ket_params_muhat3') 
save('ket_params_sahat')

end





