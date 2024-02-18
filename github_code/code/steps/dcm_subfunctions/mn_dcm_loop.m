function  [pla_mat,ket_mat]= mnket_dcm_loop(options)
%LOOP_MNKET_DCM Loops over all subjects in the MNKET study and collects dcm
%parameters for each condition
%   IN:     options     - the struct that holds all analysis options
%   OUT:    -                 

%Initialize empty matrices to collect parameters

B_pla_mat=zeros(19,12);
F_pla_mat=zeros(19,1);

B_ket_mat=zeros(19,12);
F_ket_mat=zeros(19,1);

count=1;

%Loop through each condition in each subject and run mnket_dcm 
for idCell = options.subjects.all
    id = char(idCell);
   
    for optionsCell = {'placebo','ketamine'}
        options.condition = char(optionsCell);

        [BmatrixParameters,dcmInverted.F]= mn_dcm(id,options);
        
        rvec1= [BmatrixParameters([1 8 3 10 13 18 20 23 28 29 33 36])];
        rvec2= [dcmInverted.F];

        
        switch options.condition
            case 'placebo' 
            B_pla_mat(count,:)= rvec1;
            F_pla_mat(count,:)= rvec2.F;


            case 'ketamine' 
            B_ket_mat(count,:)= rvec1;
            F_ket_mat(count,:)= rvec2.F;
        end
    end
    count=count+1;


pla_mat=horzcat(B_pla_mat,F_pla_mat) ;
ket_mat=horzcat(B_ket_mat,F_ket_mat) ;

end

